# encoding: UTF-8

class NonLicensedPlayer
  # non licensed players will be stored in the players table, even though they have no license.
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Translation
  extend ActiveModel::Naming

  attr_accessor :first_name, :name, :email, :group, :tournament_id, :keep_informed

  validates_presence_of :first_name, :name, :tournament_id
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_length_of :content, :maximum => 500

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
