# encoding: UTF-8

class NonLicensedRegistration
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attr_accessor :name, :first_name, :group, :email, :year_of_birth, :keep_informed,
                :tournament, :tournament_id, :errors
  PATTERN=/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates_presence_of :name
  validates_presence_of :first_name
  validates_presence_of :group
  validates_format_of :email, :with => PATTERN

  def initialize(name = "", first_name="", email="", year_of_birth=2000, keep_informed=false)
    self.name=name
    self.first_name = first_name
    self.email = email
    self.year_of_birth = year_of_birth
    self.keep_informed = keep_informed
    self.errors = ActiveModel::Errors.new(nil)
  end

  def persisted?
    false
  end
end