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
      inscription_player.errors.add :base, "Speichern von 0 Serien für die Warteliste am #{tournament_day.day_name} ist sinnlos."
    elsif series.size > tournament_day.series_per_day  then
      inscription_player.errors.add :base, "Am #{tournament_day.day_name} dürfen nicht mehr als #{tournament_day.series_per_day} Serien belegt werden."
    end
  end

  def must_be_allowed_to_play_all_series
    series.each do |seri|
      errors.add :base,("#{inscription_player.player.name} darf Serie #{seri.long_name} nicht spielen!") if not seri.may_be_played_by? inscription_player.player
    end
  end

  def series_list
    series.collect{|ser| ser.long_name}.join(", ")   
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
