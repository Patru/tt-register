require 'base64'

class InscriptionsController < ApplicationController
  before_filter :login_required,
                :except => [:new, :create, :show, :login, :resend,
                            :resend_link, :protection, :email_form, :mail_team]
  layout nil
  # GET /inscriptions
  # GET /inscriptions.xml
  def index
    @inscriptions = Inscription.find :all, :include => :tournament

    respond_to do |format|
      format.html # index.rb
      format.xml  { render :xml => @inscriptions }
    end
  end

  # GET /inscriptions/1
  # GET /inscriptions/1.xml
  def show
    @inscription = Inscription.find(params[:id], :include => [:tournament, {:inscription_players => [:player, :series]}])
    @inscription.tournament.build_series_map

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
    @inscription.tournament = Tournament.next

    respond_to do |format|
      format.html # new.rb
      format.xml  { render :xml => @inscription }
    end
  end

  def email_form
    if @email.nil?
      from = @inscription.email if @inscription
      @email = Email.new(from)
    end
    respond_to do |format|
      format.html # email_form.rb
    end
  end

  def protection
    respond_to do |format|
      format.html # protection.rb
    end
  end

  def mail_team
    tournament=Tournament.find(params[:tournament_id]) unless params[:tournament_id].blank?
    @email = Email.new(params[:email][:from], params[:email][:subject], params[:email][:text])
    if @email.valid?
      Confirmation.deliver_mail_team(@email, tournament.sender_email)
      flash[:notice] = "Herzlichen Dank, die Email wurde dem Turnier-Team zugestellt, es wird sich bei Bedarf melden."
      redirect_to :controller => "inscriptions", :action => "new"
    else
      render :action => "email_form"
    end

  end

  def resend_link
    @tournaments = Tournament.all
    @inscription = Inscription.new
    @inscription.tournament = Tournament.next

    respond_to do |format|
      format.html # resend.rb
      format.xml  { render :xml => @inscription }
    end
  end

  def resend
    @tournaments = Tournament.all
    @inscription = Inscription.new(params[:inscription])

    if @inscription.email.blank? then
      flash[:error] = "Bitte Email-Adresse erfassen um Link zuzustellen!"
    else
      inscription = Inscription.find_by_tournament_id_and_email(@inscription.tournament_id, @inscription.email)
      if inscription.nil? then
        flash[:error] = "Keine Einschreibung für #{inscription.email}, bitte neue Einschreibung erzeugen"
        redirect_to :controller => "inscriptions", :action => "new"
        return
      else
        inscription.create_secret
        Confirmation.deliver_resend(inscription, host)
        inscription.save
        flash[:notice] = "Link neu zugestellt, die Email sollte in wenigen Minuten ankommen."
      end
    end

    respond_to do |format|
      format.html { render :action => "resend_link" }
      format.xml  { render :xml => @inscription }
    end
  end

  # GET /inscriptions/1/edit
  def edit
    @tournaments = Tournament.all
    @inscription = Inscription.find(params[:id])
    if @inscription.id != session[:id] and @admin.nil? then
      flash[:error] = "Die Einschreibung kann von dir nicht geändert werden."
      redirect_to @inscription
      return
    end
  end

  # POST /inscriptions
  # POST /inscriptions.xml
  def create
    @inscription = Inscription.new(params[:inscription])
    if not @inscription.valid? then
      @tournaments = Tournament.all
      render :action => :new
      return
    end
    if @inscription.licence then
      if Inscription.find_by_licence_and_tournament_id @inscription.licence, @inscription.tournament_id then
        flash[:error] = "Eine Einschreibung für die Lizenznummer #{@inscription.licence} existiert bereits, bitte Login-Link neu anfordern"
        @tournaments = Tournament.all
        redirect_to :action => "new"
        return
      else
        if Player.find_by_licence(@inscription.licence).nil? then
          flash[:error] = "Kein Spieler für Lizenznummer #{@inscription.licence}, bitte eine gültige Lizenznummer verwenden"
          @tournaments = Tournament.all
          redirect_to :action => "new"
          return
        end
      end
    end
    if @inscription.email then
      if Inscription.find_by_email_and_tournament_id @inscription.email, @inscription.tournament_id then
        flash[:error] = "Eine Einschreibung für die Email-Adresse #{@inscription.email} existiert bereits, bitte Login-Link neu anfordern"
        @tournaments = Tournament.all
        redirect_to :action => "new"
        return
      end
    end
    add_name_if_missing @inscription
    @inscription.create_secret
    
    respond_to do |format|
      if @inscription.save
        Confirmation.deliver_confirmation(@inscription, host)
        flash[:notice] = 'Die Einschreibung wurde erfolgreich erzeugt, bitte den Link in der Bestätigungs-Email verwenden.'
        format.html { redirect_to(@inscription) }
        format.xml  { render :xml => @inscription, :status => :created, :location => @inscription }
      else
        @tournaments = Tournament.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @inscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /inscriptions/1
  # PUT /inscriptions/1.xml
  def update
    if session[:id] != params[:id].to_i and @admin.nil? then
      flash[:error] = "Nur die eigene Einschreibung kann geändert werden!"
      redirect_to inscriptions_url
      return
    end
    @inscription = Inscription.find(params[:id])
    add_name_if_missing @inscription

    respond_to do |format|
      @inscription.name=params[:inscription][:name]
      if @inscription.save
        flash[:notice] = 'Einschreibung erfolgreich geändert.'
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
      flash[:error] = "Nur die eigene Einschreibung kann gelöscht werden!"
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
    flash[:notice]="Keine Selektionskriterien angegeben, erste 30 Spieler angezeigt" unless criteria.size > 0
    @player_count = Player.count(:conditions => criteria)
    if @player_count > 0 then
      Player.all(:conditions => criteria, :order => "club, name, first_name", :limit => 100)
    else
      like_criteria = criteria.to_like_conditions
      @player_count = Player.count(:conditions => like_criteria)
      Player.all(:conditions => like_criteria, :order => "club, name, first_name", :limit => 30)
    end
  end
  
  def login
    @inscription = Inscription.find(params[:id])
    if @inscription.matches?(params[:token]) then
      flash[:notice] = "#{@inscription.name} eingeloggt!"
      session[:id] = @inscription.id
      session[:expires]=[Time.now+7.days,
                         (@inscription.tournament.tournament_days.maximum(:day)+1.day).to_time].min
      redirect_to @inscription
    else
      flash[:error] = "Link nicht korrekt (#{params[:token]} nicht aktuell), bitte neu anfordern falls nicht mehr vorhanden!"
      redirect_to(new_inscription_url)
    end
  rescue
    flash[:notice] = "Einschreibung Nummer #{params[:id]} nicht gefunden, bitte neu anmelden."
    redirect_to(new_inscription_url)
  end

  def logout
    session[:id] = nil
    redirect_to(new_inscription_url, :notice => "Herzlichen Dank für den Besuch.")
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
            TransferInscription.deliver_transfer_inscription(@inscription, @inscription_player, former_inscription)
            flash[:notice] = 'Die Einschreibung wurde erfolgreich übertragen und kann jetzt vom Spieler verwaltet werden.'
            format.html { redirect_to(former_inscription) }
            format.xml  { render :xml => former_inscription, :status => :created, :location => former_inscription }
          end
        else
          @tournaments = Tournament.all
          flash[:error] = "Fehler beim Übertragen der Einschreibung"
            format.html { redirect_to(former_inscription) }
          format.xml  { render :xml => @inscription.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def host
    "#{request.host_with_port}"
  end
end
