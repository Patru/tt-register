# encoding: UTF-8

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include HttpAcceptLanguage

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :set_admin_inscription, :except => [:login]
  before_filter :set_locale

protected
  def set_admin_inscription
    if (!defined?(@admin) || @admin.nil?) and session[:admin_id] and session[:expires] then
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
    elsif (!defined?(@inscription) || @inscription.nil?) && session[:id] &&
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
    return true if view_context.logged_in?
    access_denied
    return false
  end

  def access_denied
    flash[:error] = t(:must_be_logged_in)
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

  def guess_tournament
    if session['tour_id'].nil?
      @tournament=Tournament.next
    else
      @tournament=Tournament.where(id:session['tour_id']).first
    end
  end

  def set_locale
    # puts "prefering #{env["HTTP_ACCEPT_LANGUAGE"]} as interaction languages"
    preferred_locale = http_accept_language.preferred_language_from I18n.available_locales
    compatible_locale = http_accept_language.compatible_language_from I18n.available_locales
    #puts "I18n.locale was #{I18n.locale}"
    I18n.locale = session[:locale] || compatible_locale || preferred_locale || I18n.default_locale
=begin (debugging block)
    print "now set to #{I18n.locale} "
    if session[:locale]
      puts "using session #{session[:locale]}"
    elsif compatible_locale
      puts "using compatible #{compatible_locale}, u-prefs: #{http_accept_language.user_preferred_languages}"\
           ", available: #{I18n.available_locales}, headers: #{request.headers['HTTP_ACCEPT_LANGUAGE']}"
    elsif preferred_locale
      puts "using preferred #{preferred_locale}"
    else
      puts "using default"
    end
=end
  end

  def render_csv(filename = nil)
    filename ||= params[:action]
    filename += '.csv'

    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain"
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
      headers['Expires'] = "0"
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end
  end

  def render_dbsv(filename = nil)
    filename ||= params[:action]
    filename += '.dbsv'

    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain"
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
      headers['Expires'] = "0"
    else
      headers["Content-Type"] ||= 'text/dbsv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end

    render :layout => false
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