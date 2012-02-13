# Initial verifier demonstrating the use of the layouter, series_parser and verifier factory methods
class Verifiers::RadioButtonTimeBox
  include Verifiers::SeriesCountVerifier

  # returns a class, for use with the Erector::widget-method
  def layouter
    Views::Widget::TournamentSeries
  end

  # parse series from params layed out by the above layouter
  def parse(param_days, tournament)
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

  def verify inscription_player
    verify_series_count inscription_player
  end
end