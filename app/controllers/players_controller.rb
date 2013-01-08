# encoding: UTF-8

require "csv"
require 'csv.rb'

class PlayersController < ApplicationController
  before_filter :admin_required, :except => :auto
   layout nil
  # GET /players
  # GET /players.xml
  def index
    @players = Player.all(:order => "club, name", :limit => 20)
    @player_count = Player.count()
    if @filter_cond.nil? then
      @filter_cond = Player.new
    else
      flash[:notice] = "filtering here"
    end

    respond_to do |format|
      format.html # index.rb
      format.xml  { render :xml => @players }
    end
  end

  def auto
    if (lic=digits_as_int(params[:term])) > 0
      if lic > 10000
        players=Player.where(["Licence like ?", "#{lic}%"]).all
      else
        players=[]
      end
    else
      (name, first_name, club) = params[:term].split(" ")
      restrictedPlayers=Player.where(['name like ?', "%#{name}%"])
      restrictedPlayers=restrictedPlayers.where(['first_name like ?', "%#{first_name}%"]) unless first_name.blank?
      restrictedPlayers=restrictedPlayers.where(['club like ?', "%#{club}%"]) unless club.blank?
      players=restrictedPlayers.limit(10).
              select("id, ranking, woman_ranking, name, first_name, club").all
    end
    respond_to do |format|
      format.js {render :json => players}
    end
  end

  def digits_as_int str
    begin
      Integer(str)
    rescue
      return -1
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        flash[:notice] = 'Player was successfully created.'
        format.html { redirect_to(@player) }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        flash[:notice] = 'Der Spieler wurde erfolgreich geändert.'
        format.html { redirect_to(@player) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end
  
  def upload
    if not params[:players].nil? then
      player_importer = PlayerImporter.new(params[:players].tempfile)
      player_importer.import
      flash[:notice] = "Total: #{player_importer.rows}, geladen: #{player_importer.imported}, \
          neu: #{player_importer.added.size}, gelöscht: #{player_importer.deleted.size}"
    else
      flash[:notice] = "Bitte Datei auswählen, nur " + params[:upload].class.to_s + " gefunden...: " + params.size.to_s
    end
    respond_to do |format|
      format.html { redirect_to(players_url)}
      format.xml  { head :ok }
    end
  end
  
  def filtered
    @filter_cond = Player.new(params[:filter_cond])
    @players = filtered_players
    respond_to do |format|
      format.html { render :action => "index"}
      format.xml  { head :ok }
    end
  end
  
  def filtered_players
    # TODO: redesign would be in order here
    conditions = {}
    [:name, :first_name, :club].each do |criteria|
      conditions[criteria] = @filter_cond.send(criteria) unless @filter_cond.send(criteria).blank?
    end
    relation = Player.where(conditions)
    @player_count = relation.count
    if @player_count > 0 then
      relation=relation.limit(100)
    else
      relation = Player.like_relation(conditions)
      @player_count = relation.count
      relation=relation.limit(30)
    end
    relation.order("club, name, first_name").all
  end
end

class PlayerImporter
  attr_reader :imported, :updated_ranking, :added, :deleted, :rows
  def initialize(file)
    @file = file
    @rows = 0
    @imported = 0
    @updated_ranking = []
    @added = []
    @deleted = []
    @existing_players_map = {}
  end
  def import
    build_existing_players_map
    CSV.foreach(@file, col_sep:"\t") do |row|
      @rows = @rows+1
      import_player_row row 
    end    
    @existing_players_map.each do |licence, pl|
      pl.destroy
      @deleted << pl
    end
  end
  
  def build_existing_players_map
    Player.where(licence: 100000..999999).all.each do |player|
      @existing_players_map[player.licence] = player
    end
  end
  
  def import_player_row(row)
    @imported = @imported+1
    pl = Player.new
    rv, pl.club, pl.first_name, pl.name, pl.category, ranking,
    woman_ranking, stt_ranking, licence = row
    pl.licence = licence.to_i
    pl.ranking = ranking.to_i
    pl.woman_ranking = woman_ranking.to_i if woman_ranking.to_i > 0
    if stt_ranking.to_i > 0 then
      pl.rank = stt_ranking.to_i if pl.male?
      pl.woman_rank = stt_ranking.to_i if pl.female?
    end
    player = @existing_players_map.delete(pl.licence)
    if player != nil then
      attrs = pl.attributes
      attrs.delete("updated_at")
      attrs.delete("created_at")
      player.attributes=attrs
      player.save
    else
      @added<<pl
      pl.save
    end
  end
end


