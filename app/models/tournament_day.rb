# encoding: UTF-8

class TournamentDay < ActiveRecord::Base
  belongs_to :tournament
  has_many :series, :order => "sex ASC, max_ranking DESC, category ASC"
  attr_accessor :series_map
  attr_accessible :tournament_id, :max_inscriptions, :day, :series_per_day, :max_single_series,
                  :max_double_series, :max_age_series, :last_inscription_time
  has_many :waiting_list_entries
  
  def day_name day_spread=2
    week_day = day.strftime("%w").to_i
    if day_spread < 6
      I18n.t('date.day_names')[week_day]
    else
      "#{(I18n.t('date.abbr_day_names')[week_day])} #{day.strftime("%d")}."
    end
  end

  def day_string
    day.strftime(I18n.t('date.formats.default'))
  end
  
  def display_name
    "#{tournament.name}: #{day_name} (#{day.strftime("%d.%m.%Y")})"
  end
  
  def short_display
    "#{tournament.tour_id}, #{day_name}"
  end
  
  def build_series_map(player=nil)
    @series_map=Hash.new{|h, k| h[k]=Array.new}
    self.series.each do |ser|
      if player.nil? or (not tournament.only_show_playable_series) or ser.may_be_played_by?(player)
        @series_map[ser.start_time_text]<<ser
      end
    end
  end
  
  def max_series
    if series_map and series_map.length > 0 then
      (max_tim, max_sers) = series_map.max {|(time1, sers1), (time2, sers2)| sers1.length <=> sers2.length}
      return max_sers.length
    else
      return 0
    end
  end
  
  def count_entries
    TournamentDay.count(:conditions => {:id => id}, :joins => {:series => :play_series})
  end
  
  def entries_remaining?
    count_entries < max_inscriptions
  end

  def check_waiting_list
    while entries_remaining? and waiting_list_entries.size > 0 do
      accepted = WaitingListEntry.first(:order => :created_at).accept_for_tournament
      if not accepted.nil?
        WaitingListAccept.accept(accepted).deliver
        # TODO: think about an acceptable reaction if accept did not work
      end
    end
  end

  def permits? inscription_player, series_count
    if not series_per_day.blank? and series_count[:total] > series_per_day
      inscription_player.errors.add :base, I18n.t('error.max_series_per_day', day: day_name, max:series_per_day)
    end
#TODO: translate the rest
    if not max_single_series.blank? and series_count[:single] > max_single_series
      inscription_player.errors.add :base, "Am #{day_name} dürfen maximal \
           #{max_single_series} Einzelserien belegt werden"
    end
    if not max_double_series.blank? and series_count[:double] > max_double_series
      inscription_player.errors.add :base, "Am #{day_name} dürfen maximal \
           #{max_double_series} Doppelserien belegt werden"
    end
    if not max_age_series.blank? and series_count[:age] > max_age_series
      inscription_player.errors.add :base, "Am #{day_name} darf maximal \
           #{max_age_series} Altersserie belegt werden"
    end
  end

  def accept_inscriptions_until
    if last_inscription_time.nil?
      tournament.accept_inscriptions_until
    else
      last_inscription_time
    end
  end

  def accepting_inscriptions?
    accept_inscriptions_until > Time.now
  end
end
