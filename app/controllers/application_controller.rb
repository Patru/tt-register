# encoding: UTF-8

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :set_admin_inscription, :except => [:login]

protected
  def set_admin_inscription
    if @admin.nil? and session[:admin_id] and session[:expires] then
      time_left = (session[:expires] - Time.now).to_i
      if time_left > 0 then
        begin
          @admin = Admin.find session[:admin_id]
        rescue
          session[:admin_id]=nil
        end
      else
        session[:admin_id]=nil
      end
    elsif @inscription.nil? && session[:id] &&
            session[:expires] && session[:expires] > Time.now then
      begin
        @inscription = Inscription.find(session[:id])
      rescue
        session[:id]=nil
      end
    end
  end

  helper_method :is_admin?

  def is_admin?
    @admin != nil
  end

  def admin_required
    return true if  @admin or Admin.first.nil?
    admin_access_denied
    return false
  end

  def login_required
    return true if @inscription or @admin
    access_denied
    return false
  end

  def access_denied
    flash[:error] = 'Zur Benutzung dieser Funktion bitte den Anmelde-Link in der Email verwenden.'
    redirect_to :controller => 'inscriptions', :action => 'new'
  end

  def admin_access_denied
    flash[:error] = 'Admin-Login nicht möglich oder abgelaufen, bitte mit dem Link neu anmelden'
    redirect_to :controller => 'inscriptions', :action => 'new'
  end

  def self.rand_str(len)
    ary = Array.new(len) { rand(256) }
    Base64.encode64(ary.pack('C*')).tr('+/','-_').chomp
  end
end

class Hash
  def to_like_conditions
    conditions = [self.keys.map{|attribute| "#{attribute} LIKE ?" }.join(" AND ")]
    conditions << self.values.map{|search_term| "%#{search_term.downcase}%" }
    conditions.flatten
  end
end

class ActiveRecord::Base
  def rand_str(len)
    ApplicationController.rand_str(len)
  end
end