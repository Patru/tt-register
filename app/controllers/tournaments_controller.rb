# encoding: UTF-8

class TournamentsController < ApplicationController
  before_filter :admin_required, :except => [:api_entries]
  layout nil
  # GET /tournaments
  # GET /tournaments.xml
  def index
    @tournaments = Tournament.all

    respond_to do |format|
      format.html  # index.rb
      format.xml  { render :xml => @tournaments }
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.xml
  def show
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      format.html # show.rb
      format.xml  { render :xml => @tournament }
    end
  end

  # GET /tournaments/new
  # GET /tournaments/new.xml
  def new
    @tournament = Tournament.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tournament }
    end
  end

  # GET /tournaments/1/edit
  def edit
    @tournament = Tournament.find(params[:id])
  end

  # POST /tournaments
  # POST /tournaments.xml
  def create
    @tournament = Tournament.new(params[:tournament])

    respond_to do |format|
      if @tournament.save
        flash[:notice] = 'Tournament was created successfully.'
        format.html { redirect_to(@tournament) }
        format.xml  { render :xml => @tournament, :status => :created, :location => @tournament }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tournament.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.xml
  def update
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        flash[:notice] = 'Tournament was successfully updated.'
        format.html { redirect_to(@tournament) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tournament.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.xml
  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to(tournaments_url) }
      format.xml  { head :ok }
    end
  end

  def download_entries
    @tournament = Tournament.find(params[:id])
    @play_series = PlaySeries.all(
        :include => [{:series => :tournament_day}, {:inscription_player => :player}, :partner],
        :conditions => ["tournament_days.tournament_id = ?", @tournament.id])
    respond_to do |format|
      format.dbsv do
        render_dbsv "entries-"+Time.now.strftime("%d-%m-%Y")
      end
      format.csv do
        render_csv "download"
      end
    end
  end

  def api_entries
    tour_id = params[:tour_id]
    if tour_id.blank?
      raise ActionController::RoutingError.new('Tournament Not Found')
    end

    tourn = Tournament.where(:tour_id => tour_id).first
    if tourn.nil?
      raise ActionController::RoutingError.new('Tournament Not Found')
    end

    if tourn.accept_api_request_for? params[:api_key]
      entries = entries_for(tourn)

      @entries_list = entries.map { |pls|
        if pls.partner.nil?
          partner_licence=nil
        else
          partner_licence=pls.partner.licence
        end
        [tour_id, pls.inscription_player.player.licence, pls.series.series_name, pls.series_rank, partner_licence]
      }
      @entries_list.unshift [:tour_id, :licence, :series_name, :rank_in_series, :partner_licence]
      respond_to do |format|
        format.csv do
          render_csv "entries"
        end
      end
    else
      raise ActionController::RoutingError.new('Tournament Not Accessible')
    end
  end

  def entries_for(tournment)
    sers = Series.includes(:tournament_day).where('tournament_days.tournament_id' => tournment.id).all
    limited_series = sers.select{|s| !s.max_participants.nil? && s.max_participants > 0}
    unlimited_series= sers.select{|s| s.max_participants.nil? || s.max_participants == 0}

    play_series_with_partner = []
    if unlimited_series.count > 0
      unlimited_ids = unlimited_series.map(&:id)
      play_series_with_partner.concat(PlaySeries.includes({:inscription_player => :player}, :partner)
                                      .where(series_id: unlimited_ids).all)
    end
    if limited_series.count > 0
      limited_ids = limited_series.map(&:id)
      Series.where(id:limited_ids).each do |ser|
        pl_sers = ser.playing.sort
        play_series_with_partner.concat(pl_sers.slice(0, ser.max_participants))
      end
    end
    play_series_with_partner
  end

  def delete_all_inscriptions
    tournament = Tournament.find(params[:id])
    Inscription.all(:conditions => {:tournament_id => tournament.id}).each do |inscription|
      inscription.destroy
    end
    redirect_to :controller => "inscriptions", :action => "new"
  end

  # api-keys for tournaments can only be created, they will only be displayed once in the flash, a hash will be stored
  def create_api_key
    @tournament = Tournament.find(params[:id])
    api_key = @tournament.create_api_key
    if api_key
      @tournament.save
      flash[:notice] = "Bitte [#{api_key}] im Client eintragen"
    else
      flash[:error] = "Fehlgeschlagen"
    end
    render "show"
  end
end
