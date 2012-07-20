module Verifiers::SeriesCountVerifier
  # verifies the number of selected series in the context of the tournament days
  def verify_series_count inscription_player
    day_series = Hash.new{|hash,key| hash[key] = [] }
    inscription_player.play_series.each do |play_ser|
      t_day = play_ser.series.tournament_day
      day_series[t_day]=day_series[t_day] << play_ser.series
    end
    day_series.each do |tour_day, seris|
      series_count = count_series_types seris
      tour_day.permits? inscription_player, series_count
    end
  end

  def count_series_types(seris)
    counts=Hash.new(0)
    seris.each do |seri|
      counts[:total] += 1
      if seri.double_series?
        counts[:double] += 1
      elsif seri.age_series?
        counts[:age] += 1
      else
        counts[:single] += 1
      end
    end
    counts
  end
end