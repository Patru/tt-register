class Inscription < ActiveRecord::Base
  belongs_to :tournament
  has_many :inscription_players, :dependent => :destroy
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "hat ein ungültiges Format"
  validate :must_have_name_or_licence
  validates_length_of :name, :maximum => 100, :message => "darf nicht länger als 100 Zeichen sein"
  validates_length_of :email, :maximum => 120, :message => "darf nicht länger als 120 Zeichen sein"
  attr_reader :password

  def must_have_name_or_licence
    if (name == nil or name.length == 0) and (licence == nil or licence.to_s.length == 0) then
      errors.add_to_base "Name oder Lizenznummer müssen ausgefüllt werden"
    elsif licence != nil and not licence.is_a? Fixnum then
      errors.add :licence, "muss eine ganze Zahl sein"
    elsif licence != nil and not (100000..999999).include? licence then
      errors.add :licence, "ist nicht zwischen 100000 und 999999"
    end
  end
  
  def anrede
    if attribute_present? :licence then
      if own_player.woman_ranking then
        return "Liebe"
      else
        return "Lieber"
      end
    else
      return "Liebe(r)"
    end
  end
  
  def own_player
    if attribute_present? :licence then
      @own_player ||= Player.find_by_licence(licence)
      return @own_player
    end
    return nil
  end
  
  def inscription_players_without_self
    split_inscription_players
    @inscription_players_without_self
  end
  
  def own_inscription
    split_inscription_players
    @own_inscription
  end
  
  def split_inscription_players
    if @inscription_players_without_self.nil?
      @inscription_players_without_self=[]
      inscription_players.each do |ins_player|
        if ins_player.player.licence != licence then
          @inscription_players_without_self << ins_player
        else
          @own_inscription = ins_player
        end
      end
    end
  end

  def matches?(login_str)
    if salt.nil? then
      return token.eql?(login_str)
    else
      return self.secret.eql?(Digest::SHA2.hexdigest(self.salt + login_str))
    end
  end

  def create_secret
    self.salt = rand_str(9)
    @password = rand_str(12)
    self.secret = Digest::SHA2.hexdigest(self.salt + @password)
  end
end
