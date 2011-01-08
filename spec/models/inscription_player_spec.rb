require 'spec_helper'

describe InscriptionPlayer do
  before(:each) do
    @valid_attributes = {
      :inscription_id => 1,
      :player_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    InscriptionPlayer.create!(@valid_attributes)
  end
end
