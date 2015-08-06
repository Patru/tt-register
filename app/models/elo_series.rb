# encoding: UTF-8

class EloSeries < Series
  def translated_name
    if min_elo
      return "#{long_name} ab Elo #{min_elo}"
    elsif max_elo
      return "#{long_name} bis Elo #{max_elo}"
    else
      return long_name
    end
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
end