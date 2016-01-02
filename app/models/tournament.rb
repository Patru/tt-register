# encoding: UTF-8

class Tournament < ActiveRecord::Base
  has_many :tournament_days
  has_many :inscriptions
  has_many :admins

  validates_presence_of :tour_id
  validates_presence_of :sender_email
  validates_presence_of :name

  def build_series_map(player=nil)
    tournament_days.each do |day|
      day.build_series_map player
    end
  end

  def self.next
    min_day = TournamentDay.minimum(:day, :conditions => ["day > ?", Time.now])
    day = TournamentDay.first(:conditions => {:day => min_day})
    if day then
      Tournament.find(day.tournament_id, :include => {:tournament_days => :series})
    else
      Tournament.new(:name => "kein aktives Turnier", :stylesheet => "/assets/neutral.css")
    end
  end

  def layouter
    layouter_parser.layouter
  end

  def parse_series(param_days)
    layouter_parser.parse param_days, self
  end

  def verify_series(inscription_player)
    layouter_parser.verify(inscription_player)
  end

  def layouter_parser
    return if layout_parser.blank?
    layouter_class=layout_parser.split('::').inject(Kernel) {|scope, const_name| scope.const_get(const_name)}
    @layout_parser ||= layouter_class.new
  end

  def day_spread
    tournament_days.map{|day| day.day}
    min_date = dates.min
    return 0 if min_date.nil?
    max_date = dates.max
    (max_date-min_date).to_i+1
  end

  def dates
    @dates||=tournament_days.map{|tour_day| tour_day.day}
  end

  def accept_inscriptions_until
    if last_inscription_time.nil?
      dates.min.to_time
    else
      last_inscription_time
    end
  end

  def thanks_for_interest_localized
    thanks_sym = ("thanks_for_interest_"+I18n.locale.to_s).to_sym
    thanks = send(thanks_sym)
    if thanks
      return thanks
    else
      return "Danke für dein interesse am " + name
    end
  end

  def active_tournament_days
    tournament_days.select do |tour_day|
      tour_day.day > Date.today-30
    end
  end
end
