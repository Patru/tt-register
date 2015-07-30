# encoding: UTF-8

class TournamentsController < ApplicationController
  before_filter :admin_required
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
      format.html # show.html.erb
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

  def delete_all_inscriptions
    tournament = Tournament.find(params[:id])
    Inscription.all(:conditions => {:tournament_id => tournament.id}).each do |inscription|
      inscription.destroy
    end
    redirect_to :controller => "inscriptions", :action => "new"
  end
end
