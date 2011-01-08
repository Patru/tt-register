class PlaySeries < ActiveRecord::Base
  include Comparable
  belongs_to :inscription_player
  belongs_to :series

  def <=>(anOther)
    str.size <=> anOther.str.size
  end

  def series_ranking
    inscription_player.series_ranking series
  end

  def series_rank
    inscription_player.series_rank series
  end

  def display_ranking
    inscription_player.display_ranking series
  end

  def <=>(other)
    rank = series_rank
    if rank.nil? then
      if other.series_rank then
        return 1   # no rank is worse than any rank
      else
        return -(series_ranking <=> other.series_ranking)  # smaller ranking is worse
      end
    else
      o_rank = other.series_rank
      if o_rank.nil? then
        return -1  # any rank is better than none
      else
        return rank <=> o_rank # bigger rank is worse
      end
    end

  end
end
