# encoding: UTF-8

class WaitingListEntry < ActiveRecord::Base
  belongs_to :tournament_day
  belongs_to :inscription_player
  has_many :waiting_list_series, :dependent => :destroy
  has_many :series, :through => :waiting_list_series
  validate :must_not_have_too_many_series
  validate :must_be_allowed_to_play_all_series

  def must_not_have_too_many_series
    if series.size == 0 then
      inscription_player.errors.add :base, t('error.no_series_pointless', day_name: tournament_day.day_name)
    elsif series.size > tournament_day.series_per_day  then
      inscription_player.errors.add :base, t('error.too_many_series', day_name: tournament_day.day_name, max:tournament_day.series_per_day)
    end
  end

  def must_be_allowed_to_play_all_series
    series.each do |seri|
      unless seri.may_be_played_by? inscription_player.player
        errors.add :base, t('error.may_not_play_series', player:inscription_player.player.name, series:seri.long_name)
      end
    end
  end

  def series_list
    series.collect{|ser| ser.translated_name}.join(", ")
  end
  
  def number_in_list
    @number_on_list ||= WaitingListEntry.count(:conditions => ["tournament_day_id = ?  AND created_at <= ?", tournament_day_id, created_at])
  end
  
  def day_list_string
    "#{tournament_day.day_name[0..1]}: #{number_in_list}"
  end
  
  def accept_for_tournament
    inscription_player.replace_day_series(tournament_day_id, series)
    if inscription_player.save then
      destroy
    else
      nil
    end
  end
end
