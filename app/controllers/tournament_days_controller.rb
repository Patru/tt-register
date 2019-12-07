# encoding: UTF-8

class TournamentDaysController < ApplicationController
  before_filter :admin_required
  layout nil
  # GET /tournament_days
  # GET /tournament_days.xml
  def index
    @tournament_days = TournamentDay.all(:include => :tournament)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tournament_days }
    end
  end

  # GET /tournament_days/1
  # GET /tournament_days/1.xml
  def show
    @tournament_day = TournamentDay.find(params[:id], :include => :tournament)
    @series = Series.find_all_by_tournament_day_id(@tournament_day.id, :include => [{:tournament_day => :tournament}], :order => "long_name")
    @tournament_days = TournamentDay.all#, :conditions => ["day >= ?", Time.now]

    respond_to do |format|
      format.html # show.erb
      format.xml  { render :xml => @tournament_day }
    end
  end

  # GET /tournament_days/new
  # GET /tournament_days/new.xml
  def new
    @tournaments = Tournament.all
    @tournament_day = TournamentDay.new

    respond_to do |format|
      format.html # new.rb
      format.xml  { render :xml => @tournament_day }
    end
  end

  # GET /tournament_days/1/edit
  def edit
    @tournaments = Tournament.all
    @tournament_day = TournamentDay.find(params[:id])
  end

  # POST /tournament_days
  # POST /tournament_days.xml
  def create
    @tournament_day = TournamentDay.new(params[:tournament_day])

    respond_to do |format|
      if @tournament_day.save
        flash[:notice] = 'TournamentDay was created successfully.'
        format.html { redirect_to(@tournament_day) }
        format.xml  { render :xml => @tournament_day, :status => :created, :location => @tournament_day }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tournament_day.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tournament_days/1
  # PUT /tournament_days/1.xml
  def update
    @tournament_day = TournamentDay.find(params[:id])

    respond_to do |format|
      if @tournament_day.update_attributes(params[:tournament_day])
        flash[:notice] = 'TournamentDay was successfully updated.'
        format.html { redirect_to(@tournament_day) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tournament_day.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tournament_days/1
  # DELETE /tournament_days/1.xml
  def destroy
    @tournament_day = TournamentDay.find(params[:id])
    @tournament_day.destroy

    respond_to do |format|
      format.html { redirect_to(tournament_days_url) }
      format.xml  { head :ok }
    end
  end
  
  # PUT /tournament_days/copy_series
  # todo: semantic integration test for this one
  def copy_series
    target = TournamentDay.find(params[:target_id])
    source = TournamentDay.find(params[:source_id])
    source.series.each do |serie|
      copy = serie.dup
      copy.tournament_day_id = target.id
      copy.save
    end

    @tournament_day = TournamentDay.find(target.id, :include => :tournament)
    respond_to do |format|
        flash[:notice] = 'Serien erfolgreich kopiert'
        format.html { redirect_to(@tournament_day) }
        format.xml  { head :ok }
    end
  end

  def download_entries
    @tournament_day = TournamentDay.find(params[:id])
    @tournament_day.series
    @play_series = PlaySeries.all(
        include:[:series, {:inscription_player => :player}, {:inscription_player => :inscription}, :partner],
        conditions:{'series.tournament_day_id' => @tournament_day.id})
    group_by_player

    respond_to do |format|
      format.dbsv do
        render_dbsv "entries-"+Time.now.strftime("%d-%m-%Y")
      end
      format.csv do
        render_csv "day_entries-#{Time.now.strftime("%d-%m-%Y_%k:%M")}"
      end
    end
  end

  def waiting_list
    @tournament_day = TournamentDay.find(params[:id])
    @tournament_day.series
    @waiting_list_entries=WaitingListEntry.includes(inscription_player: [:inscription, :player]).
        where(tournament_day_id:id).
        order(:created_at)

    respond_to do |format|
      format.html # waiting_list.rb
    end
  end

  def elo_entries
    @tournament_day = TournamentDay.find(params[:id])
    play_series = PlaySeries.all(
        include:[:series, {:inscription_player => :player}, {:inscription_player => :inscription}],
        conditions:{'series.tournament_day_id' => @tournament_day.id})
    @entries = []
    @entries << [:licence, :name, :first_name, :club, :elo, :email]
    play_series.each do |ps|
      pl = ps.player
      inscription = ps.inscription_player.inscription
      @entries << [pl.licence, pl.name, pl.first_name, pl.club, pl.elo, inscription.email]
    end

    respond_to do |format|
      format.csv do
        render_csv "elo_entries-#{Time.now.strftime("%d-%m-%Y_%k:%M")}"
      end
    end
  end

  def group_by_player
    all_sers = @tournament_day.series.sort { |s1, s2| s1.series_name <=> s2.series_name }
    player_series = Hash.new{|h, k| h[k]=PlayerSeries.new(all_sers)}
    @play_series.each do |pls|
      player_series[pls.player]=(player_series[pls.player]<<pls)
    end
    headers = ["Verein", "Liz.Nr.", "Name", "Vorname", "E-Mail", "Kat.", "Kla H", "Kla D", "Klub D"]
    all_sers.each do |ser|
      headers << ser.series_name
    end
    headers.concat ["Partner", "Lizenz", "Mixed Partner", "Mix.Liz."]
    @pl_list =[headers]
    player_series.keys.sort{|pl1, pl2| pl1.ranking <=> pl2.ranking}.each do |pl|
      @pl_list << player_series[pl].line
    end
  end
end
