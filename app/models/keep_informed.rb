class KeepInformed < ActiveRecord::Base
  belongs_to :tournament
  attr_accessible :create_inscription, :email, :tournament_id, :unlicensed, :salutation

  def line
    [email, unlicensed]
  end
end
