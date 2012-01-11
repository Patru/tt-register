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
      if not @series_map.has_key?(time)
        @series_map[time]=[]
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
end
