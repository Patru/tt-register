# encoding: UTF-8
class Inscription < ActiveRecord::Base
  belongs_to :tournament
  has_many :inscription_players, :dependent => :destroy
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                      :message => I18n.t(:invalid_format, scope:[:errors, :messages])
  validate :must_have_name_or_licence
  validates_length_of :name, :maximum => 100, :message => "darf nicht länger als 100 Zeichen sein"
  validates_length_of :email, :maximum => 120, :message => "darf nicht länger als 120 Zeichen sein"
  attr_reader :password
  attr_accessor :keep_informed
  attr_accessible :tournament_id, :email, :licence, :name, :keep_informed

  def must_have_name_or_licence
    if (name == nil or name.length == 0) and (licence == nil or licence.to_s.length == 0) then
      errors.add :base, I18n.t(:name_or_licence_filled, scope:[:errors, :messages])
    elsif licence != nil and not licence.is_a? Fixnum then
      errors.add :licence, I18n.t(:not_an_integer, scope:[:errors, :messages])
    elsif licence != nil and not (100000..999999).include? licence then
      errors.add :licence, I18n.t(:must_be_in_licence_range, scope:[:errors, :messages])
    end
  end
  
  def anrede
    if attribute_present? :licence then
      if own_player && own_player.woman_ranking then
        return I18n.t 'salutation.her'
      else
        return I18n.t 'salutation.him'
      end
    else
      return I18n.t 'salutation.both'
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
    unless defined?(@inscription_players_without_self) and @inscription_players_without_self
      @own_inscription = nil
      @inscription_players_without_self=[]
      inscription_players.each do |ins_player|
        if ins_player.player.nil?
          puts "player not available in InscriptionPlayer #{ins_player.id}"
        elsif ins_player.player.licence != licence then
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

  # checkboxes are strange beasts
  def keep_informed?
    return keep_informed == "1"
  end

  def unlicensed?
    pl = own_player
    if not pl.nil?
      return pl.ranking == 0
    end
  end
end
