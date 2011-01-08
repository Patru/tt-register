class QuarksController < ApplicationController
  # GET /quarks
  # GET /quarks.xml
  def index
    @quarks = Quark.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quarks }
    end
  end

  # GET /quarks/1
  # GET /quarks/1.xml
  def show
    @quark = Quark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quark }
    end
  end

  # GET /quarks/new
  # GET /quarks/new.xml
  def new
    @quark = Quark.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quark }
    end
  end

  # GET /quarks/1/edit
  def edit
    @quark = Quark.find(params[:id])
  end

  # POST /quarks
  # POST /quarks.xml
  def create
    @quark = Quark.new(params[:quark])

    respond_to do |format|
      if @quark.save
        flash[:notice] = 'Quark was successfully created.'
        format.html { redirect_to(@quark) }
        format.xml  { render :xml => @quark, :status => :created, :location => @quark }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quark.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quarks/1
  # PUT /quarks/1.xml
  def update
    @quark = Quark.find(params[:id])

    respond_to do |format|
      if @quark.update_attributes(params[:quark])
        flash[:notice] = 'Quark was successfully updated.'
        format.html { redirect_to(@quark) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quark.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quarks/1
  # DELETE /quarks/1.xml
  def destroy
    @quark = Quark.find(params[:id])
    @quark.destroy

    respond_to do |format|
      format.html { redirect_to(quarks_url) }
      format.xml  { head :ok }
    end
  end
end
