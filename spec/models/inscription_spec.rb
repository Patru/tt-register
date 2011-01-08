require 'spec_helper'

describe Inscription do
  before(:each) do
    @valid_attributes = {
      :tournament_id => 1,
      :licence => 111111,
      :name => "value for name",
      :email => "a@b.cd",
      :token => "value for token"
    }
  end

  it "should create a new instance given valid attributes" do
    Inscription.create!(@valid_attributes)
  end

  it "should not allow records with neither licence nor name" do
    inscription = Inscription.create( :tournament_id => 1, :email => "a@b.cd", :token => "value for token")
    inscription.should_not be_valid
    inscription = Inscription.create( :tournament_id => 1, :licence => "", :name => "", :email => "a@b.cd", :token => "value for token")
    inscription.should_not be_valid
  end

  it "should not allow records with non-numeric licences" do
    inscription = Inscription.create( :tournament_id => 1, :licence => 1.1, :name => "", :email => "a@b.cd", :token => "value for token")
    inscription.should_not be_valid
  end
end
