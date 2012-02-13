class PlaySeries < ActiveRecord::Base
  include Comparable
  belongs_to :inscription_player
  belongs_to :series
  belongs_to :partner, :class_name => "Player"

  def series_ranking
    inscription_player.series_ranking series
  end

  def series_rank
    inscription_player.series_rank series
  end

  def display_ranking
    display = ranking.to_s
    my_rank = rank
    display << " (#{rank})" if rank
    return display
  end

  def series_string
    if partner_id.nil?
      series.long_name
    else
      "#{series.long_name} (#{partner.long_name})"
    end
  end

  def list_name
    if partner_id.nil?
      inscription_player.player.long_name
    else
      "#{inscription_player.player.long_name}/#{partner.long_name}"
    end
  end

  def list_club
    if partner_id.nil?
      inscription_player.player.club
    else
      if inscription_player.player.club == partner.club
        parnter.club
      else
        "#{inscription_player.player.club}/#{partner.club}"
      end
    end
  end

  def <=>(other)
    my_rank = rank
    if my_rank.nil? then
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
        return my_rank <=> o_rank # bigger rank is worse
      end
    end
  end

  def ranking
    rk=series.ranking_of inscription_player.player
    rk=rk + series.ranking_of(partner) unless partner_id.nil?
    rk
  end

  # rank according to the target series, all doubles will have no rank at all
  def rank
    series.rank_of inscription_player.player
  end
end
