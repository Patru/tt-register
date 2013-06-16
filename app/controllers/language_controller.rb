class LanguageController < ApplicationController
  before_filter :admin_required, :except => :set_language
  def set_language
    lang = params['language']
    if lang
      lang_sym=lang.to_sym
      if I18n.available_locales.include? lang_sym
        return set_locale_and_redirect lang_sym
      end
    end
    redirect_to root_path
  end

private
  def set_locale_and_redirect (locale)
    I18n.locale = locale
    session[:locale] = locale
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

end
