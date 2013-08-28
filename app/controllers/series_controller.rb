# encoding: UTF-8

class SeriesController < ApplicationController
  before_filter :admin_required, :except => [:players]
  layout=nil
  # GET /series
  # GET /series.xml
  def index
    @series = Series.all(:order => "long_name", :include => [{:tournament_day => :tournament}])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @series }
    end
  end

  # GET /series/1
  # GET /series/1.xml
  def show
    @series = Series.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @series }
    end
  end

  def players
    @series = Series.find(params[:id], :include => {:inscription_players => :player})
    @play_series = @series.playing.sort
    @open=@series.open

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @series }
    end
  end

  # GET /series/new
  # GET /series/new.xml
  def new
    @series = Series.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @series }
    end
  end

  # GET /series/1/edit
  def edit
    @series = Series.find(params[:id])
  end

  # POST /series
  # POST /series.xml
  def create
    @series = Series.new(params[:series])
    @series.normalize_start_time
    @series.type=determine_series_type(params[:series][:type])

    respond_to do |format|
      if @series.save
        flash[:notice] = 'Serie erfolgreich erzeugt.'
        format.html { redirect_to(@series) }
        format.xml  { render :xml => @series, :status => :created, :location => @series }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @series.errors, :status => :unprocessable_entity }
      end
    end
  end

  def determine_series_type(ser_type)
    unless ser_type.blank?
      if /double/i.match ser_type
        return DoubleSeries.name
      elsif /mixed/i.match ser_type
        return MixedSeries.name
      end
    end
    nil
  end

  # PUT /series/1
  # PUT /series/1.xml
  def update
    @series = Series.find(params[:id])
    
    respond_to do |format|
      params[:series][:type]=determine_series_type(params[:series][:type])
      if @series.update_attributes(params[:series])
        flash[:notice] = 'Serie erfolgreich gespeichert.'
        format.html { redirect_to(series_url(@series)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @series.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /series/1
  # DELETE /series/1.xml
  def destroy
    @series = Series.find(params[:id])
    @series.destroy

    respond_to do |format|
      format.html { redirect_to(series_index_path) }
      format.xml  { head :ok }
    end
  end
end
