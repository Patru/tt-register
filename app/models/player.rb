# encoding: UTF-8

class Player < ActiveRecord::Base
  has_many :inscription_players
  validates_length_of :name, :maximum => 100, :message => "darf nicht länger als 100 Zeichen sein"
  validates_length_of :first_name, :maximum => 100, :message => "darf nicht länger als 100 Zeichen sein"
  validates_length_of :club, :maximum => 100, :message => "darf nicht länger als 100 Zeichen sein"

  def self.like_relation(criteria)
    relation = self
    arel_table = relation.arel_table
    criteria.each do |key, like|
      relation=relation.where(arel_table[key].matches "%#{like}%")
    end
    relation
  end

  def male?
    return woman_ranking.nil?
  end

  def female?
    return (not woman_ranking.nil?)
  end

  def matches_category?(cat)
    if cat.starts_with? "U" then
      return (category.starts_with? "U") && (category <= cat)
    elsif cat.starts_with? "O" then
      return (category.starts_with? "O") && (category >= cat)
    else
      return true
    end
  end
  
  def long_name
    first_name + " " + name
  end
  
  def player_info
    info = letter_ranking(ranking)
    info << "/#{letter_ranking woman_ranking}" unless male?
    info << "; " << category unless category.eql? "-"
    info << " (Elo #{elo})"
    return info
  end
  
  def letter_ranking(rking)
    case rking
      when 1..5 then "D#{rking}"
      when 6..10 then "C#{rking}"
      when 11..15 then "B#{rking}"
      when 16..20 then "A#{rking}"
    end
  end

  def disp_ranking
    disp = letter_ranking(ranking)
    disp << " (#{rank})" if rank
    disp
  end

  def disp_woman_ranking
    disp = letter_ranking(woman_ranking)
    disp << " (#{woman_rank})" if woman_rank
    disp
  end

  def third_person
    if male? then
      return I18n.t 'pronoun.he'
    else
      return I18n.t 'pronoun.she'
    end
  end

  def description
    "#{name} #{first_name}, #{club} (#{both_rankings})"
  end

  def both_rankings
    if woman_ranking.nil?
      ranking.to_s
    else
      "#{ranking}/#{woman_ranking}"
    end
  end
end

