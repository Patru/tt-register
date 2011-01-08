require 'spec_helper'

describe "/tournament_days/index.rb" do
  include TournamentDaysHelper

  before(:each) do
    assigns[:tournament_days] = @tournament_days = [
      stub_model(TournamentDay,
        :tournament_id => 1,
        :max_inscriptions => 1
      ),
      stub_model(TournamentDay,
        :tournament_id => 1,
        :max_inscriptions => 1
      )
    ]
  end

  it "renders a list of tournament_days" do
    assigns[:tournament_days].should_not be_nil 
    @tournament_days.should_not be_nil
    render(:locals => {:tournament_days => @tournament_days}) 
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
