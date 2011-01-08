require 'spec_helper'

describe PlaySeries do
  before(:each) do
    @valid_attributes = {
      :inscription_player_id => 1,
      :series_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    PlaySeries.create!(@valid_attributes)
  end
end
