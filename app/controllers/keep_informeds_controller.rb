# encoding: UTF-8

class KeepInformedsController < ApplicationController
  before_filter :admin_required
  layout nil

  def show
    @keep_informed = KeepInformed.find(params[:id])

    respond_to do |format|
      format.html # show.rb
    end
  end

  # GET /keep_informeds/new
  def new
    @keep_informed = KeepInformed.new

    respond_to do |format|
      format.html # new.erb
    end
  end

  # GET /keep_informeds/1/edit
  def edit
    @keep_informed = KeepInformed.find(params[:id])
  end

  def update
    @keepInformed = KeepInformed.find(params[:id])

    respond_to do |format|
      if @keepInformed.update_attributes(params[:keep_informed])
        puts "success"
        flash[:notice] = 'Die Adresse wurde erfolgreich geändert.'
        format.html { redirect_to(@keepInformed) }
      else
        puts "something went wrong"
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    keep_informed = KeepInformed.find(params[:id])

    if keep_informed.destroy
      flash[:notice] = "Adresse gelöscht"
      redirect_to tournament_emails_url(id:keep_informed.tournament_id, format:'html')
    end
  end
end
