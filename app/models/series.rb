class Series < ActiveRecord::Base
  belongs_to :tournament_day
  has_many :play_series
  has_many :inscription_players, :through => :play_series
  has_many :waiting_list_series
  
  def normalize_start_time
    hour=start_time.hour
    min=start_time.min
    start_time=Time.local(2000, 1, 1, hour, min)
  end
  
  def start_time_text
    start_time.strftime("%R")
  end
  
  def may_be_played_by?(player)
    return matches_sex?(player) && matches_category?(player) && matches_ranking_of?(player)
  end
  
  def matches_sex?(player)
    if male? then
      return player.male?
    elsif female? then
        return !player.male?
    else #unspecified
      return true
    end
  end
  
  def matches_category?(player)
    if category != nil and category.length > 0 then
      return player.matches_category?(category)
    else
      return true
    end
  end
  
  def matches_ranking_of?(player)
    if female?
      return matches_ranking?(player.woman_ranking)
    else
      return matches_ranking?(player.ranking)
    end
  end
  
  def matches_ranking?(ranking)
    return (min_ranking..max_ranking).include?(ranking) 
  end
  
  def female?
    return sex.eql?("W")
  end
  
  def male?
    return sex.eql?("M")
  end
  
  def <=>(other)
    if cat_order == other.cat_order then
      if cat_order == 3
        return -(long_name <=> other.long_name)
      else
        non_cat_compare other
      end
    else
      cat_order <=> other.cat_order 
    end
  end
  
  def cat_order
    case category[0..0]
      when "O" then 1
      when "-" then 2
      when "U" then 3
      else 0
    end
  end
  
  def non_cat_compare(other)
    if female? then
      if not other.female? then
        return -3
      end
    else
      if other.female? then
        return 3
      end
    end
    -(max_ranking <=> other.max_ranking)
  end

  def relevant_ranking
    return :woman_ranking if female?
    :ranking
  end

  def relevant_rank
    return :woman_rank if female?
    :rank
  end

  def ranking_of(player)
    player.send(relevant_ranking)
  end

  def rank_of(player)
    rank = player.send(relevant_rank)
    return rank if rank and use_rank and rank <= use_rank
    return nil
  end

  def double_series?
    self.class != Series
  end

  def age_series?
    not category.blank?
  end

  # verify if partner matches series criteria
  # we also have to pass the inscription player as the association is created anew upon request
  def verify_partners(inscription_player, play_ser)
    if play_ser.partner
      inscription_player.errors.add_to_base("Kein Partner für #{long_name} erlaubt!")
    end
  end

  def playing
    return play_series
  end

  def open
    return []
  end
end

class Models::Series < Series
  
end