# Initial verifier demonstrating the use of the layouter, series_parser and verifier factory methods
class Verifiers::RadioButtonTimeBox

  # returns a class, for use with the Erector::widget-method
  def layouter
    Views::Widget::TournamentSeries
  end

  # parse series from params layed out with above layouter
  def parse(param_days)
    sel_days = {}
    param_days.each do |day_id, starts|
      ser_ids = []
      starts.each do |time, ser|
        ser_ids << ser unless ser.eql? 'keine'
      end
      sel_days[day_id] = ser_ids unless ser_ids.blank?
    end
    sel_days
  end

  # verifies the selected series in the context of the tournament days
  def verify inscription_player
    day_series = Hash.new([])
    inscription_player.series.each do |seri|
      day_series[seri.tournament_day]=day_series[seri.tournament_day] << seri
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