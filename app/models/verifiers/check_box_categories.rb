class Verifiers::CheckBoxCategories <Verifiers::RadioButtonTimeBox
  def layouter
    Views::Widget::SeriesBox
  end

  def parse(param_days)
    sel_days = {}
    partner_ids = {}
    param_days.each do |day_id, series_info|
      ser_ids = []
      series_info.each do |ser_id, checked|
        ser_ids << ser_id.to_i if checked == "1"
      end
      series_info[:partner_ids].each do  |ser_id, partner_id|
        partner_ids[ser_id.to_i]=partner_id.to_i unless partner_id.blank?
      end
      sel_days[day_id] = ser_ids unless ser_ids.blank?
    end
    [sel_days, partner_ids]
  end
end