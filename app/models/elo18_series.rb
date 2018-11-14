# encoding: UTF-8
require_relative 'elo_series'

class Elo18Series < EloSeries

  def nav_name
    @nav_name ||= I18n.t(:elo_18_nav_name)
  end

  def translated_name
    return I18n.translate :elo_12
  end

  def lister
    :Elo18Lister
  end

end