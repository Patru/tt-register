# encoding: UTF-8

module InscriptionsHelper
  def logged_in?
    (defined?(@inscription) and @inscription) or (defined?(@admin) and @admin)
  end
end
