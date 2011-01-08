require 'spec_helper'

describe "/tournament_days/show.rb" do
  include TournamentDaysHelper
  before(:each) do
    assigns[:tournament_day] = @tournament_day = stub_model(TournamentDay,
      :tournament_id => 1,
      :max_inscriptions => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
