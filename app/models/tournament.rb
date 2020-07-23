# encoding: UTF-8

class Tournament < ActiveRecord::Base
  has_many :tournament_days
  has_many :inscriptions
  has_many :admins
  has_many :keep_informeds

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

  def remark_localized
    remark_sym = ("remark_"+I18n.locale.to_s).to_sym
    remark = send(remark_sym)
    if remark
      return remark
    else
      return ""
    end
  end

  def active_tournament_days
    tournament_days.select do |tour_day|
      tour_day.day > Date.today-30
    end
  end

  def hash_key(key)
    self.salt = rand_str(20) if self.salt.nil?
    Digest::SHA2.hexdigest(self.salt + key)
  end

  def create_api_key()
    api_key = rand_str(20)
    self.hashed_api_key = hash_key(api_key)
    api_key
  end

  def accept_api_request_for?(key)
    return self.hashed_api_key.eql?(hash_key(key))
  end

  def non_licensed_series?
    self.non_licensed_series != nil
  end

  def non_licensed_series
    if !defined?(@non_licensed_series)
      active_tournament_days.each do |day|
        day.series.each do |ser|
          if ser.non_licensed?
            return @non_licensed_series = ser
          end
        end
      end
      @non_licensed_series = nil
    end
    return @non_licensed_series
  end

  def next_non_licensed_number
    if non_licensed_series?
      lic_start = non_licensed_series.non_licensed_start
      lic_end = lic_start+999
      current = Player.where(licence:lic_start..lic_end).maximum(:licence)
      if !current.nil? && current >= lic_start
        return current+1
      else
        return lic_start
      end
    end
    return 0
  end

  def waiting_list_series
    WaitingListSeries.joins(waiting_list_entry: :tournament_day)
        .includes(:series, waiting_list_entry: {inscription_player: :player}).where(tournament_days: {tournament_id: id})
  end
end
