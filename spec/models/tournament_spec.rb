require 'spec_helper'

describe Tournament do
  before(:each) do
    @valid_attributes = {
      :tour_id => "ZhOpen",
      :name => "Zürich Open",
    }
  end

  it "should create a new instance given valid attributes" do
    Tournament.create!(@valid_attributes)
  end
end
