# encoding: UTF-8
require 'base64'

class InscriptionsController < ApplicationController
  before_filter :login_required,
                :except => [:new, :create, :show, :login, :resend,
                            :resend_link, :protection, :email_form, :mail_team,
                            :with_id, :new_non_licensed, :register_non_licensed]
  layout nil
  # GET /inscriptions
  # GET /inscriptions.xml
  def index
    @inscriptions = Inscription.includes(:tournament).all

    respond_to do |format|
      format.html # index.rb
      format.xml  { render :xml => @inscriptions }
    end
  end

  # GET /inscriptions/1
  # GET /inscriptions/1.xml
  def show
    @inscription = Inscription.where(id:params[:id]).
            includes(:tournament,  :inscription_players => [:player, :series]).first
    @inscription.tournament.build_series_map @inscription.own_player

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @inscription }
    end
  end

  # GET /inscriptions/new
  # GET /inscriptions/new.xml
  def new
    @tournaments = Tournament.all
    @inscription = Inscription.new
    @inscription.tournament = guess_tournament

    respond_to do |format|
      format.html # new.rb
      format.xml  { render :xml => @inscription }
    end
  end

  def email_form
    guess_tournament
    unless defined?(@email)
      from = @inscription.email if defined?(@inscription)
      @email = Email.new(from)
    end
    respond_to do |format|
      format.html # email_form.rb
    end
  end

  def protection
    guess_tournament
    respond_to do |format|
      format.html # protection.rb
    end
  end

  def mail_team
    tournament=Tournament.find(params[:tournament_id]) unless params[:tournament_id].blank?
    @email = Email.new(params[:email][:from], params[:email][:subject], params[:email][:text])
    if @email.valid?
      Confirmation.mail_team(@email, tournament.sender_email).deliver
      flash[:notice] = t 'flash.thanks_we_will_get_back_to_you'
      redirect_to :controller => "inscriptions", :action => "new"
    else
      render :action => "email_form"
    end
  end

  def resend_link
    @tournaments = Tournament.all
    @inscription = Inscription.new
    @inscription.tournament = guess_tournament

    respond_to do |format|
      format.html # resend.rb
      format.xml  { render :xml => @inscription }
    end
  end

  def new_non_licensed
    @tournaments = Tournament.all  # TODO: scope for all non-licensed tournemnts
    @registration = NonLicensedRegistration.new
    @registration.tournament = guess_tournament
    @registration.tournament_id = @registration.tournament.id

    respond_to do |format|
      format.html # new_non_licensed.rb
    end
  end

  def register_non_licensed
    nlr = params[:non_licensed_registration]
    tournament_id = nlr[:tournament_id].to_i
    tournament = Tournament.find(tournament_id)
    if tournament.nil?
      flash[:error] = "Ohne Turnier ist keine Anmeldung möglich."
      render :new_non_licensed
      return
    end

    @inscription = Inscription.where(tournament_id:tournament.id, email:nlr[:email]).first
    if @inscription.nil?
      @inscription = Inscription.new(name:"#{nlr[:first_name]} #{nlr[:name]}", email:nlr[:email],
                            tournament_id:tournament.id, keep_informed:nlr[:keep_informed])
      @inscription.create_secret
      if @inscription.save
        flash[:notice]="Einschreibung für #{@inscription.name} erstellt."
        Confirmation.non_licensed_account(@inscription, host).deliver
      end
    end

    @player = Player.new(name:nlr[:name], first_name:nlr[:first_name], ranking:0, club:nlr[:group])
    @player.licence = tournament.next_non_licensed_number
    logger.info "Player mit: #{@player.licence}"
    @player.save
    logger.info "Player erstellt: #{@player.id}"

    if (!@inscription.id.nil?) && (!@player.id.nil?)
      logger.info "erstelle ip"
      ip = InscriptionPlayer.new(inscription_id:@inscription.id, player_id:@player.id)
      if ip.save
        logger.info "ip und ps erstellt"
        ip.reload
        if @inscription.licence.nil?
          @inscription.licence = @player.licence
          @inscription.save
        else
          Confirmation.non_licensed_registration(@inscription, host).deliver
        end
        flash[:notice] = "Der Spieler #{@player.long_name} wurde auf dem Konto von #{@inscription.name} angemeldet"
        logger.info "ip gespeichert, erzeuge ps"
        ser = tournament.non_licensed_series
        logger.info "trying to add #{ser.series_name}"
        ps = ip.play_series.build(series:ser, partner:nil)
        logger.info "now we have #{ps.series_id}"
        if ps.save
          logger.info "ps gespeichert"
        else
          logger.info "da ging was schief"
        end
      end
    else
      logger.error "Fehler ins: #{@inscription.id} pl: #{@player.id}"
    end
    create_keep_informed(@inscription) if @inscription.keep_informed?

    redirect_to @inscription
  end

  def resend
    @tournaments = Tournament.all
    @inscription = Inscription.new(params[:inscription])

    if @inscription.email.blank? then
      flash[:error] = t 'flash.please_provide_email'
    else
      inscription = Inscription.find_by_tournament_id_and_email(@inscription.tournament_id, @inscription.email)
      if inscription.nil? then
        flash[:error] = t('flash.no_inscription_for', address:@inscription.email)
        redirect_to :controller => "inscriptions", :action => "new"
        return
      else
        inscription.create_secret
        Confirmation.resend(inscription, host).deliver
        inscription.save
        flash[:notice] = t 'flash.new_link_has_been_created'
      end
    end

    respond_to do |format|
      format.html { redirect_to :action => "email_form" }
      format.xml  { render :xml => @inscription }
    end
  end

  # GET /inscriptions/1/edit
  def edit
    @tournaments = Tournament.all
    @inscription = Inscription.find(params[:id])
    if @inscription.id != session[:id] and @admin.nil? then
      flash[:error] = t 'error.may_only_edit_own_inscription'
      redirect_to @inscription
      return
    end
  end

  # POST /inscriptions
  # POST /inscriptions.xml
  def create
    @inscription = Inscription.new(params[:inscription])
    @inscription.email.strip!
    if not @inscription.valid? then
      # This would not work, tell the user why this is
      @tournaments = Tournament.all
      render :action => :new
      return
    end
    if @inscription.licence then
      if Inscription.find_by_licence_and_tournament_id @inscription.licence, @inscription.tournament_id then
        flash[:error] = t('flash.inscription_exists', licence: @inscription.licence)
        @tournaments = Tournament.all
        redirect_to :action => "new"
        return
      else
        if Player.find_by_licence(@inscription.licence).nil? then
          flash[:error] = t 'flash.no_player_for_licence', licence: @inscription.licence
          @tournaments = Tournament.all
          redirect_to :action => "new"
          return
        end
      end
    end
    if @inscription.email then
      if Inscription.find_by_email_and_tournament_id @inscription.email, @inscription.tournament_id then
        flash[:error] = t 'flash.inscription_for_email_exists', address: @inscription.email
        @tournaments = Tournament.all
        redirect_to :action => "new"
        return
      end
    end
    add_name_if_missing @inscription
    @inscription.create_secret
    
    respond_to do |format|
      if @inscription.save
        create_keep_informed(@inscription) if @inscription.keep_informed?
        Confirmation.confirmation(@inscription, host).deliver
        flash[:notice] = t 'flash.inscription_form_created_successfully'
        format.html { redirect_to(@inscription) }
        format.xml  { render :xml => @inscription, :status => :created, :location => @inscription }
      else
        flash[:notice] = 'inscription could not be saved'
        @tournaments = Tournament.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @inscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_keep_informed(inscription)
    keep_informed = KeepInformed.new
    keep_informed.email = inscription.email
    keep_informed.tournament = inscription.tournament
    keep_informed.unlicensened = inscription.unlicensed?
    keep_informed.save
  end

  # PUT /inscriptions/1
  # PUT /inscriptions/1.xml
  def update
    if session[:id] != params[:id].to_i and @admin.nil? then
      flash[:error] = t 'error.may_only_edit_own_inscription'
      redirect_to inscriptions_url
      return
    end
    @inscription = Inscription.find(params[:id])
    add_name_if_missing @inscription

    respond_to do |format|
      @inscription.name=params[:inscription][:name]
      if @inscription.save
        flash[:notice] = t 'notice.inscription_edited_success'
        format.html { redirect_to(@inscription) }
        format.xml  { head :ok }
      else
        @tournaments = Tournament.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @inscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /inscriptions/1
  # DELETE /inscriptions/1.xml
  def destroy
    if session[:id] != params[:id] and @admin.nil? then
      flash[:error] = t 'error.may_only_delete_own_inscription'
      redirect_to inscriptions_url
      return
    end
    @inscription = Inscription.find(params[:id])
    @inscription.destroy

    respond_to do |format|
      format.html { redirect_to(inscriptions_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_name_if_missing(inscription)
    if inscription.name.blank? then
      player = Player.find_by_licence @inscription.licence
      inscription.name = player.long_name if player
    end
  end
  
  def select_player
    crit = Player.new(params[:crit])
    if not crit.valid? then
      flash[:error] = crit.errors.full_messages[0]
      redirect_to @inscription
      return
    end
    @players = filtered_players(crit)
    respond_to do |format|
      format.html
      format.xml  { head :ok }
    end
  end
  
  def filtered_players(crits)
    criteria = {}
    [:name, :first_name, :club].each do |crit|
      criteria[crit] = crits.send(crit) unless crits.send(crit).blank?
    end
    max_players=100
    flash[:notice]= t('flash.no_selection_criteria', max: max_players) unless criteria.size > 0
    relation = Player.where(criteria)
    @player_count = relation.count
    if @player_count > 0 then
      relation=relation.limit(max_players)
    else
      relation = Player.like_relation(criteria)
      @player_count = relation.count
      relation=relation.limit(30)
    end
    relation.order("club, name, first_name").all
  end

  def login
    @inscription = Inscription.find(params[:id])
    if @inscription.matches?(params[:token]) then
      flash[:notice] = t('flash.logged_in', name:@inscription.name)
      session[:id] = @inscription.id
      session[:expires]=[Time.now+7.days,
                         (@inscription.tournament.tournament_days.maximum(:day)+1.day).to_time].min
      redirect_to @inscription
    else
      flash[:error] = t 'flash.login_link_incorrect', token: params[:token]
      redirect_to(new_inscription_url)
    end
  rescue
    flash[:notice] = t 'flash.inscription_not_found', id: params[:id]
    redirect_to(new_inscription_url)
  end

  def logout
    session[:id] = nil
    redirect_to(new_inscription_url, notice: t('notice.thanks_for_your_visit'))
  end
  
  def own_inscription
    @inscription_player = InscriptionPlayer.find params[:id], :include => [:player, {:inscription => :tournament}]
    @inscription = Inscription.new
    @inscription.tournament = @inscription_player.inscription.tournament
    @inscription.licence = @inscription_player.player.licence
    @inscription.name = @inscription_player.player.long_name

    respond_to do |format|
      format.html # own_inscription.rb
      format.xml  { render :xml => @inscription }
    end
  end
  
  def transfer_player
    @inscription_player = InscriptionPlayer.find(params[:inscription_player_id])
    former_inscription = @inscription_player.inscription
    @inscription = Inscription.new(params[:inscription])
    @inscription.create_secret
    
    respond_to do |format|
      InscriptionPlayer.transaction do
        if @inscription.save
          @inscription_player.inscription = @inscription
          if @inscription_player.save then
            TransferInscription.transfer_inscription(@inscription, @inscription_player, former_inscription, host).deliver
            flash[:notice] = t 'notice.transfer_successful'
            format.html { redirect_to(former_inscription) }
            format.xml  { render :xml => former_inscription, :status => :created, :location => former_inscription }
          end
        else
          @tournaments = Tournament.all
          flash[:error] = t 'error.while_transfering_inscription'
            format.html { redirect_to(former_inscription) }
          format.xml  { render :xml => @inscription.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def with_id
    tourn=Tournament.where(tour_id:params['id'].upcase).first
    session['tour_id']=tourn.id unless tourn.nil?

    redirect_to action:'new'
  end

  def host
    request.host_with_port
  end
end
