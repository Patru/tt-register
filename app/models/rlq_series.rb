# encoding: UTF-8

class RlqSeries < Series

  # does not sound clean, but I lack the time for a decent abstraction TODO
=begin
  def ranking_of(player)
    player.elo
  end
=end

  def lister
    :ParticipationLister
  end
end