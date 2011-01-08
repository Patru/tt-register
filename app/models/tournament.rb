class Tournament < ActiveRecord::Base
  has_many :tournament_days
  has_many :inscriptions
  has_many :admins
  
  def build_series_map
    tournament_days.each do |day|
      day.build_series_map
    end
  end
  
  def self.next
    min_day = TournamentDay.minimum(:day, :conditions => ["day > ?", Time.now])
    day = TournamentDay.first(:conditions => {:day => min_day})
    Tournament.find(day.tournament_id, :include => {:tournament_days => :series})
  end
end
class Models::Tournament < Tournament

end