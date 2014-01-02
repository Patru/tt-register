# encoding: UTF-8

class AdminsController < ApplicationController
  before_filter :admin_required, :except => [:login, :verify_login]
  layout :resolve_layout

  def login
    @admin = Admin.first(:conditions => {:token => params[:token]})
    respond_to do |format|
      format.html 
    end
  end

  def verify_login
    admin = Admin.new params[:admin]
    db_admin = Admin.first(:conditions => {:token => admin.token})
    if db_admin and db_admin.matches?(admin) then
      session[:admin_id]=db_admin.id
      session[:expires]=Time.now+2.hours
      flash[:notice] = "#{admin.name} eingeloggt"
      redirect_to :controller => 'inscriptions', :action => 'index'
    elsif db_admin.nil? then
      flash[:notice] = "Admin auf der DB nicht vorhanden"
      @admin = admin
      render :action => 'login'
    else
      @admin = admin
      flash[:error] = "Passwort falsch, nochmal versuchen"
      render :action => 'login'
    end
  end

  # GET /admins
  # GET /admins.xml
  def index
    @admins = Admin.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
    end
  end

  # GET /admins/1
  # GET /admins/1.xml
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/new
  # GET /admins/new.xml
  def new
    admin = Admin.first
    if admin then
      if @admin then
        @admin = Admin.new(:token => ApplicationController::rand_str(12))
      else
        flash[:notice] = "Sie müssen Administrator sein um einen Administrator zu erzeugen"
        redirect_to :controller=>"inscriptions", :action => "new"
        return
      end
    else
      @admin = Admin.new(:token => ApplicationController.rand_str(12))
    end

    respond_to do |format|
      format.html {render :action => 'new'}
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
  end

  # POST /admins
  # POST /admins.xml
  def create
    @new_admin = Admin.new(params[:admin])
    @new_admin.hash_password
    sender_admin = @admin?@admin:@new_admin

    respond_to do |format|
      if @new_admin.save
        Confirmation.admin_confirmation(@new_admin, sender_admin, request.host_with_port).deliver
        flash[:notice] = 'Admin gespeichert, Login Link per E-mail zugestellt.'
        @admins = Admin.all
        format.html { redirect_to :action => :index }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/1
  # PUT /admins/1.xml
  def update
    @admin = Admin.find(params[:id])

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        flash[:notice] = 'Admin was successfully updated.'
        format.html { redirect_to(@admin) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admins_url) }
      format.xml  { head :ok }
    end
  end

  def logoff
    session[:admin_id] = nil
    redirect_to :controller => 'inscriptions', :action => 'new'
  end

private
  def resolve_layout
    case action_name
    when "new", "index", "new", "update"
      "admins_layout"
    else
      nil
    end

  end
end
