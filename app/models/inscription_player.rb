# encoding: UTF-8

class InscriptionPlayer < ActiveRecord::Base
  belongs_to :inscription
  belongs_to :player
  has_many :play_series, :dependent => :destroy
  has_many :series, :through => :play_series
  has_many :waiting_list_entries, :dependent => :destroy
  validate :series_ok_for_tournament
  attr_accessor :notices
  after_initialize :do_after_initialize

  def do_after_initialize
    self.notices ||= []
  end

  def set_series(days)
    ser_ids = []
    days.each do |day_id, starts|
      starts.each do |time, ser_id|
        ser_ids << ser_id unless ser_id.eql?'keine'
      end
    end
    series.replace(unique_day_time_series(ser_ids))
  end

  def unique_day_time_series(ser_ids)
    seris = Series.all(:conditions => {:id => ser_ids})
    day_time = {}
    sers = []
    seris.each do |seri|
      da_tim = seri.day_id.to_s + "/" + seri.start_time_text
      unless day_time.has_key?(da_tim) then
        day_time[da_tim] = seri
        series << seri
      end
    end
    series
  end
  
  def replace_day_ser_ids(day_id, ser_ids)
    seris = Series.all(:conditions => {:id => ser_ids})
    replace_day_series day_id, seris
  end
  
  def replace_day_series(day_id, seris)
    srs = series.select{|ser| ser.tournament_day_id != day_id}
    series.replace(srs.concat(seris))
  end

  def day_series(day_id)
    series.select{|ser| ser.tournament_day_id == day_id}
  end
  
  def create_waiting_list_entry(day_id, ser_ids)
    entry = WaitingListEntry.new(:tournament_day_id => day_id)
    entry.inscription_player = self
    sers = Series.all(:conditions => {:id => ser_ids})
    entry.series.replace(sers)
    waiting_list_entries << entry
  end
  
  def inscribed_for
    texts = []
    texts << inscribed_series if play_series.size > 0
    texts << waiting_lists if waiting_list_entries.size > 0
    texts.join "; "
  end
  
  def inscribed_series
    play_series.collect{|pl_ser| pl_ser.series_string}.join(", ")
  end
  
  def waiting_lists
    I18n.t(:short, scope: :waiting_list) + " " + waiting_list_entries.collect{|entry| entry.day_list_string}.join(", ")
  end
  
  def ranking
    player.ranking
  end
  
  def woman_ranking
    player.woman_ranking
  end
  
  def self.find_with_licence_and_tournament(licence, tournament_id)
    InscriptionPlayer.first(:include => [:player, {:inscription => :tournament}],
        :conditions => ["players.licence = ? AND inscriptions.tournament_id = ?",  licence, tournament_id])
  end

  def self.find_with_player_and_tournament_id(player, tournament_id)
    InscriptionPlayer.first(:include => [:player, {:inscription => :tournament}],
        :conditions => ["player_id = ? AND inscriptions.tournament_id = ?",  player.id, tournament_id])
  end

  def series_in_tour_day
    t_days=series.reduce(Hash.new([])) do |days, ser| days[ser.tournament_day] << ser end
  end

  def series_per_day
    day_series = {}
    series.each do |seri|
      t_day = seri.tournament_day
      if day_series.has_key? t_day then
        day_series[t_day] = day_series[t_day]+1
      else
        day_series[t_day] = 1
      end
      unless seri.may_be_played_by? self.player
        errors.add :base, t(:may_not_play_series, player:self.player.name, series:seri.translated_name, scope: :error)
      end
    end
    day_series.each do |tour_day, val|
      if val > tour_day.series_per_day
        errors.add :base, t(:max_series_per_day, day: tour_day.day_name, max: tour_day.series_per_day, scope: :error)
      end
    end
  end

  def series_ok_for_tournament
    inscription.tournament.verify_series self
    play_series.each do |pl_ser|
      seri=pl_ser.series
      if not seri.accepting_inscriptions?
        errors.add :base, I18n.t('error.accept_inscription_until', series: seri.long_name,
                                    time: I18n.l(seri.tournament_day.accept_inscriptions_until, format: :short))
      end
      if not seri.may_be_played_by? self.player
        errors.add :base, ("#{self.player.name} darf Serie #{seri.long_name} nicht spielen!")
        # translate!
      end
    end
  end

  def no_series_selected?
    series.empty? and waiting_list_entries.empty? and play_series.empty?
  end

  def series_ranking(series)
    player.send(series.relevant_ranking)
  end

  def series_rank(series)
    if player.nil?
      puts "own player not found: #{created_at}"
      return 0
    end
    rank = player.send(series.relevant_rank)
    return rank if rank and series.use_rank and rank <= series.use_rank
    return nil
  end

  def build_series_map
    inscription.tournament.build_series_map player
  end

  def all_series_past_end_of_inscriptions?
    day_ids=series.collect{|seri| seri.tournament_day_id}.uniq
    day_ids.concat(waiting_list_entries.collect{|seri| seri.tournament_day_id}.uniq)
    TournamentDay.find(day_ids).each do |tour_day|
      if tour_day.accepting_inscriptions?
        return false
      end
    end
    return true
  end
end
