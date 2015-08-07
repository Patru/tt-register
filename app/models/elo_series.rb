# encoding: UTF-8

class EloSeries < Series
  def translated_name
    if min_elo
      if max_elo
        return I18n.translate :elo_12_min_max, min:min_elo, max:max_elo
      else
        return I18n.translate :elo_12_min, min:min_elo
      end
    elsif max_elo
      return I18n.translate :elo_12_max, max:max_elo
    else
      return I18n.translate :elo_12
    end
  end

  def table_headers
    [:name, :club, :elo]
  end

  def nav_name
    @nav_name ||= "#{I18n.t(:elo_nav_name)} #{I18n.localize(tournament_day.day, format: :abr_day)}"
  end

  def may_be_played_by?(player)
    return matches_elo?(player)
  end

  def matches_elo? player
    if min_elo
      if max_elo
        return (min_elo..max_elo).include? player.elo
      else
        return min_elo <= player.elo
      end
    else
      if max_elo
        return max_elo >= player.elo
      end
    end
    return true
  end

  # does not sound clean, but I lack the time for a decent abstraction TODO
  def ranking_of(player)
    player.elo
  end
end