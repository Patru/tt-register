require 'spec_helper'

describe TournamentDay do
  before(:each) do
    @valid_attributes = {
      :tournament_id => 1,
      :day => Date.new(2010, 2, 20),
      :max_inscriptions => 1
    }
  end

  it "should create a new instance given valid attributes" do
    TournamentDay.create!(@valid_attributes)
  end
  
  it "should return the day of week in german" do
    t_day = TournamentDay.new(@valid_attributes)
    t_day.day.should_not be_nil
    t_day.day_name.should eql("Samstag")
    t_day.day=Date.new(2010, 2, 21)
    t_day.day_name.should eql("Sonntag")
  end
  
  it "should have a meaningful display_name" do
    t_day = TournamentDay.new(@valid_attributes)
    tournament_attributes = {
      :tour_id => "ZhOpen",
      :name => "Zürich Open",
    }
    t_day.tournament = Tournament.new(tournament_attributes)
    t_day.display_name.should eql("Zürich Open: Samstag (20.02.2010)")
  end
  
  it "shoud have a meaningful short_display" do
    t_day = TournamentDay.new(@valid_attributes)
    tournament_attributes = {
      :tour_id => "ZhOpen",
      :name => "Zürich Open",
    }
    t_day.tournament = Tournament.new(tournament_attributes)
    t_day.short_display.should eql("ZhOpen, Samstag")
  end
    
end
