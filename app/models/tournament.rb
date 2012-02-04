class Tournament < ActiveRecord::Base
  has_many :tournament_days
  has_many :inscriptions
  has_many :admins

  validates_presence_of :tour_id
  validates_presence_of :sender_email
  validates_presence_of :name

  def build_series_map
    tournament_days.each do |day|
      day.build_series_map
    end
  end
  
  def self.next
    min_day = TournamentDay.minimum(:day, :conditions => ["day > ?", Time.now])
    day = TournamentDay.first(:conditions => {:day => min_day})
    if day then
      Tournament.find(day.tournament_id, :include => {:tournament_days => :series})
    else
      Tournament.new(:name => "keines", :stylesheet => "/stylesheets/neutral.css")
    end
  end

  def layouter
    layouter_parser.layouter
  end

  def parse_series(param_days)
    layouter_parser.parse param_days
  end

  def verify_series(inscription_player)
    layouter_parser.verify(inscription_player)
  end

  def layouter_parser
    return if layout_parser.blank?
    layouter_class=layout_parser.split('::').inject(Kernel) {|scope, const_name| scope.const_get(const_name)}
    @layout_parser ||= layouter_class.new
  end
end

class Models::Tournament < Tournament

end