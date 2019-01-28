class KeepInformed < ActiveRecord::Base
  belongs_to :tournament
  attr_accessible :create_inscription, :email, :tournament_id, :unlicensened

  def line
    [email, unlicensened]
  end
end
