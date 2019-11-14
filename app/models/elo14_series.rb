# encoding: UTF-8

class Elo14Series < EloSeries

  def lister
    :Elo14Lister
  end

  def nav_key
    :elo_14_nav_name
  end

  def elo_min_min_max_key
    :elo_14_min_max
  end

  def elo_min_key
    :elo_14_min
  end

  def elo_max_key
    :elo_14_max
  end

  def elo_key
    :elo_14
  end


end