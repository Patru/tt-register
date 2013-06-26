# encoding: UTF-8

module InscriptionsHelper
  def logged_in?
    @inscription or @admin
  end
end
