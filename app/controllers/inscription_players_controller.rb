class InscriptionPlayersController < ApplicationController
  before_filter :login_required, :except => [:show]
  layout nil
  # GET /inscription_players
  # GET /inscription_players.xml
  def index
    @inscription_players = InscriptionPlayer.find :all, :include => :inscription

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @inscription_players }
    end
  end

  # GET /inscription_players/1
  # GET /inscription_players/1.xml
  def show
    @inscription_player = InscriptionPlayer.find(params[:id],
        :include => [:player, :inscription, :series, {:waiting_list_entries => [:series, :tournament_day]}])
    @player = @inscription_player.player
    @inscription = @inscription_player.inscription
    @inscription.tournament.build_series_map
    @go_back_to_list = true if params[:go_back_to_list]
    if @inscription_player.waiting_list_entries.size > 0 then
      @inscription_player.waiting_list_entries.map{|entry| entry.number_in_list}
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @inscription_player }
    end
  end

  # GET /inscription_players/new
  # GET /inscription_players/new.xml
  def new
    @inscription_player = InscriptionPlayer.new

    respond_to do |format|
      format.html { render :action => "show" }
      format.xml  { render :xml => @inscription_player }
    end
  end

  def new_player
    respond_to do |format|
      format.html { }
    end
  end

  # GET /inscription_players/1/edit
  def edit
    @inscription_player = InscriptionPlayer.find(params[:id], :include => [{:inscription => :tournament}, :player, :series])
    if (@inscription.nil? or @inscription_player.inscription_id != @inscription.id) and @admin.nil? then
      flash[:error] = "#{@inscription_player.player.long_name} wurde von #{@inscription_player.inscription.name} angemeldet, die Anmeldung kann deshalb nicht geändert werden."
      redirect_to @inscription_player
      return
    end
    @inscription_player.inscription.tournament.build_series_map
    respond_to do |format|
      if @inscription_player.inscription.id == session[:id] then
        format.html # edit.rb
        format.xml  { render :xml => @inscription_player.errors, :status => :unprocessable_entity }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @inscription_player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /inscription_players
  # POST /inscription_players.xml
  def create
    @inscription_player = InscriptionPlayer.new(params[:inscription_player])

    respond_to do |format|
      if @inscription_player.save
        flash[:notice] = 'InscriptionPlayer was successfully created.'
        format.html { redirect_to(@inscription_player) }
        format.xml  { render :xml => @inscription_player, :status => :created,
                             :location => @inscription_player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @inscription_player.errors,
                             :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /inscription_players/1
  # DELETE /inscription_players/1.xml
  def destroy
    @inscription_player = InscriptionPlayer.find(params[:id])
    if @inscription_player.inscription_id != @inscription.id then
      flash[:error] = "Falsche Einschreibung, #{@inscription_player.player.long_name} kann nicht abgemeldet werden."
      redirect_to @inscription_player
      return
    end
    inscription = @inscription_player.inscription
    flash[:notice] = "#{@inscription_player.player.long_name} wurde abgemeldet"
    Confirmation.deliver_deregistration(@inscription_player)
    @inscription_player.destroy
    check_waiting_list inscription

    respond_to do |format|
      if inscription then
        format.html { redirect_to inscription }
      else
        format.html { redirect_to(inscription_players_url) }
        format.xml  { head :ok }
      end
    end
  end

  def player_ok?
    if @player.nil?
      flash[:error] = "Kein Spieler mit Lizenz #{params[:licence]} gefunden"
      redirect_to @inscription
    end
    return @player
  end

  def fetch_player_by_licence(licence)
    @player = Player.find_by_licence(licence)
    return player_ok?
  end

  def fetch_player_by_id(id)
    @player = Player.find_by_id(id)
    return player_ok?
  end

  def licence_too_long?(licence)
    if licence.length > 10 then
      flash[:error] = "Lizenz darf höchstens 10 Zeichen lang sein!"
      redirect_to @inscription
      return true
    end
    return false
  end

  def fetch_inscription_player(player, tournament_id)
    @inscription_player = InscriptionPlayer.find_with_player_and_tournament_id(player, tournament_id)
    if @inscription_player then
      flash[:error] = "#{@inscription_player.player.long_name} wurde bereits von #{@inscription_player.inscription.name} angemeldet! #{@inscription_player.player.third_person} kann nicht noch einmal angemeldet werden."
      redirect_to @inscription_player
    end
    return @inscription_player
  end


  def add_player
    return if licence_too_long?(params[:licence])
    return if not fetch_player_by_licence(params[:licence])
    return if fetch_inscription_player(@player, @inscription.tournament_id)
    @inscription.tournament.build_series_map
    respond_to do |format|
      if @player then
        flash[:notice] = "Bitte Serien auswählen um die Anmeldung abzuschliessen."
        format.html { render(:action => "new_player") }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @inscription_player.errors, :status => :unprocessable_entity }
      end
    end
  end

  def player
    return if not fetch_player_by_id(params[:id])
    return if fetch_inscription_player(@player, @inscription.tournament_id)
    @inscription.tournament.build_series_map
    respond_to do |format|
      format.html {render :action => 'new_player'}
    end
  end

  # Neue Anmeldung
  def enroll
    tournament = Tournament.find(params[:tournament_id])
    if (params.has_key? :id) then
      @inscription_player = InscriptionPlayer.find(params[:id], :include => :tournament)
    else
      player = Player.find(params[:player_id])
      if (@inscription.tournament_id == tournament.id) then
        if InscriptionPlayer.find_with_player_and_tournament_id(player, tournament.id) then
          flash[:error] = "#{player.long_name} ist bereits angemeldet, neue Anmeldung ignoriert."
          redirect_to @inscription
          return
        end
        @inscription_player = new_ins_player player, params[:start]
        if @inscription_player.no_series_selected? then
          flash[:error] = "Keine Serie selektiert, nicht gespeichert"
          prepare_new_player @inscription_player
          render :action => :new_player
          return
        end

        respond_to do |format|
          if @inscription_player.save then
            Confirmation.deliver_inscription_player_confirmation(@inscription_player)
            if player.eql?(@inscription.own_player) then
              flash[:notice] = "Deine Anmeldung wurde gespeichert."
              format.html { redirect_to(@inscription_player.inscription) }
            else
              flash[:notice] = "Anmeldung von #{@inscription_player.player.long_name} wurde gespeichert."
              format.html { redirect_to(:action => :show, :id => @inscription_player.id, :go_back_to_list => true) }
              format.xml  { head :ok }
            end
          else
            prepare_new_player @inscription_player
            format.html {
              render :action => "new_player"
            }
            format.xml  { render :xml => @inscription_player.errors, :status => :unprocessable_entity }
          end
        end
      else
        flash[:error]="Keine Einschreibung für dieses Turnier"
      end
    end
  end

  def prepare_new_player(inscription_player)
    @player = inscription_player.player
    @inscription = inscription_player.inscription
    @inscription.tournament.build_series_map
    @sel_series = inscription_player.series
  end
  
  def new_ins_player(player, param_days)
    inscription_player = InscriptionPlayer.new(:player_id => player.id, :inscription_id => @inscription.id)
    day_ids, partner_ids=@inscription.tournament.parse_series(param_days)
    #TODO use a decent transaction here ...
    day_ids.each do |day_id, ser_ids|
      td = TournamentDay.find(day_id)
      if td.entries_remaining? then
        inscription_player.replace_day_ser_ids td.id, ser_ids
      elsif ser_ids.size > 0 then
        inscription_player.create_waiting_list_entry td.id, ser_ids
      end
    end
    # usually this would happen automagically upon save, but we cannot wait until then and have to add the partners now
    inscription_player.series.each do |ser|
      play_ser=inscription_player.play_series.build(:series => ser, :partner_id => partner_ids[ser.id])
    end
    inscription_player.series.replace([])   # avoid automatic doubling of series?
    return inscription_player
  end

  # PUT /inscription_players/1
  # PUT /inscription_players/1.xml
  def update_series
    @inscription_player = InscriptionPlayer.find(params[:id])
    if @inscription_player.inscription_id != @inscription.id then
      flash[:error] = "Falsche Einschreibung, #{@inscription_player.player.long_name} kann nicht geändert werden."
      redirect_to @inscription_player
      return
    end
    success_notice = "Anmeldung erfolgreich geändert."
    days, partner_ids=@inscription_player.inscription.tournament.parse_series(params[:start])
    all_series = []
    days.each do |day_id, sers|
      day = TournamentDay.find(day_id)
      if day.entries_remaining? then
        all_series.concat(Series.all(:conditions => {:id => sers}))
      else
        day_sers = @inscription_player.day_series(day.id)
        if day_sers.size >= sers.size then
          all_series.concat(Series.all(:conditions => {:id => sers}))
        else
          @inscription_player.errors.add_to_base "Für den #{day.day_name} sind keine Meldungen mehr frei, maximal #{day_sers.size} Serien wählen."
        end
      end
    end
    if @inscription_player.play_series.empty?
      success_notice = "Keine Serien übrig, bitte #{@inscription_player.player.long_name} abmelden."
    end

    respond_to do |format|
      begin
        if @inscription_player.errors.size > 0
          throws ActiveRecord::RecordInvalid.new(@inscription_player)
        end
        save_with_series!(@inscription_player, all_series, partner_ids)
        Confirmation.deliver_inscription_player_update(@inscription_player)
        check_waiting_list @inscription_player.inscription
        if @inscription_player.notices.empty?
          flash[:notice] = success_notice
        else
          flash[:notice] = @inscription_player.notices.join("; ")
        end
        format.html { redirect_to(@inscription_player) }
        format.xml  { head :ok }
      rescue
        @inscription_player.inscription.tournament.build_series_map
        format.html { render :action => "edit" }
        format.xml  { render :xml => @inscription_player.errors, :status => :unprocessable_entity }
      end
    end
  end

  def replace_day_ser_ids(day_id, ser_ids)
    seris = Series.all(:conditions => {:id => ser_ids})
    replace_day_series day_id, seris
  end

  def save_with_series!(ins_player, sers, partner_ids)
    InscriptionPlayer.transaction do
      ins_player.series.replace(sers)
      unless partner_ids.empty?
        @inscription_player.play_series.each do |play_ser|
          play_ser.partner_id=partner_ids[play_ser.series_id]
        end
      end
      ins_player.save!

      ins_player.play_series.each do |pl_ser|
        pl_ser.save!
      end
    end
  end

  def check_waiting_list(inscription)
    inscription.tournament.tournament_days.each do |tour_day|
      tour_day.check_waiting_list
    end
  end
end
