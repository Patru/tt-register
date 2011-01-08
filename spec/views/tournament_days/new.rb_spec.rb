require 'spec_helper'
require 'config/routes.rb'

describe Views::TournamentDays::New do
  include TournamentDaysHelper

  before(:each) do
    @day1 = stub_model(TournamentDay,
      :new_record? => true,
      :tournament_id => 1,
      :max_inscriptions => 1
    )
    @zh_open = stub_model(Tournament,
      :new_record? => false,
      :tournament_id => 1,
      :name => "Zürich Open"
    )
  end

  it "renders new tournament_day form" do
    @day1.should_not be_nil
    @zh_open.should_not be_nil
    @tournament_day = @day1
    @tournaments = [@zh_open]
    @widget = Views::TournamentDays::New.new(:tournament_day => @day1, :tournaments => [@zh_open])
#    @widget.to_s
    render @widget

    response.should have_tag("form[action=?][method=post]", tournament_days_path) do
      with_tag("input#tournament_day_tournament_id[name=?]", "tournament_day[tournament_id]")
      with_tag("input#tournament_day_max_inscriptions[name=?]", "tournament_day[max_inscriptions]")
    end
  end
end
