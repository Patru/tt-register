class TournamentDay < ActiveRecord::Base
  @@weekdays = ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"]
  belongs_to :tournament
  has_many :series, :order => "sex ASC, max_ranking DESC, category ASC"
  attr_accessor :series_map
  has_many :waiting_list_entries
  
  def day_name
    @@weekdays[day.strftime("%w").to_i]
  end
  
  def display_name
    "#{tournament.name}: #{day_name} (#{day.strftime("%d.%m.%Y")})"
  end
  
  def short_display
    "#{tournament.tour_id}, #{day_name}"
  end
  
  def build_series_map
    @series_map={}
    self.series.each do |ser|
      time = ser.start_time_text
      unless @series_map.has_key?(time)
        @series_map[time]=[]   # a default for the hash will not work!
      end
      @series_map[time]<<ser
    end
  end
  
  def max_series
    if series_map.length > 0 then
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
    while entries_remaining? and waiting_list_entries.count > 0 do
      WaitingListEntry.first(:order => :created_at).accept_for_tournament
    end
  end

  def permits? inscription_player, series_count
    if not series_per_day.blank? and series_count[:total] > series_per_day
      inscription_player.errors.add_to_base("Am #{day_name} dürfen maximal \
           #{series_per_day} Serien belegt werden")
    end
    if not max_single_series.blank? and series_count[:single] > max_single_series
      inscription_player.errors.add_to_base("Am #{day_name} dürfen maximal \
           #{max_single_series} Einzelserien belegt werden")
    end
    if not max_double_series.blank? and series_count[:double] > max_double_series
      inscription_player.errors.add_to_base("Am #{day_name} dürfen maximal \
           #{max_double_series} Doppelserien belegt werden")
    end
    if not max_age_series.blank? and series_count[:age] > max_age_series
      inscription_player.errors.add_to_base("Am #{day_name} darf maximal \
           #{max_age_series} Altersserie belegt werden")
    end
  end
end
