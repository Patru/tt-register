class Verifiers::CheckBoxCategories <Verifiers::RadioButtonTimeBox
  include Verifiers::SeriesCountVerifier

  def layouter
    Views::Widget::SeriesBox
  end

  # make sure to return an entry for every tournament day of the current tournament!
  def parse(param_days, tournament)
    sel_days = {}
    tournament.tournament_days.each do |tour_day|
      sel_days[tour_day.id]=[]
    end
    partner_ids = {}
    param_days.each do |day_id, series_info|
      ser_ids = []
      series_info.each do |ser_id, checked|
        ser_ids << ser_id.to_i if checked == "1"
      end
      series_info[:partner_ids].each do  |ser_id, partner_id|
        partner_ids[ser_id.to_i]=partner_id.to_i unless partner_id.blank?
      end
      sel_days[day_id.to_i] = ser_ids unless ser_ids.blank?
    end
    [sel_days, partner_ids]
  end

  def verify inscription_player
    verify_series_count inscription_player
    verify_doubles_partners inscription_player
  end

  def verify_doubles_partners inscription_player
    inscription_player.play_series.each do |play_ser|
      if play_ser.partner
        play_ser.series.verify_partners(inscription_player, play_ser)
      end
    end
  end
end