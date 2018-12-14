# encoding: UTF-8
require_relative 'elo_series'

class Elo18Series < EloSeries

  def nav_name
    @nav_name ||= I18n.t(:elo_18_nav_name)
  end

  def translated_name
    if max_elo
      return I18n.translate :elo_18_max, max:max_elo
    else
      return I18n.translate :elo_18
  end

  def lister
    :Elo18Lister
  end

end