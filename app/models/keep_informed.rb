class KeepInformed < ActiveRecord::Base
  belongs_to :tournament
  attr_accessible :create_inscription, :email, :tournament_id, :unlicensed, :salutation, :licence, :language

  # this is used for the CSV export
  def line
    [email, unlicensed, licence, salutation, language]
  end
end
