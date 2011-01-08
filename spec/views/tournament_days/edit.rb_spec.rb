require 'spec_helper'

describe "/tournament_days/edit.rb" do
  include TournamentDaysHelper

  before(:each) do
    assigns[:tournament_day] = @tournament_day = stub_model(TournamentDay,
      :new_record? => false,
      :tournament_id => 1,
      :max_inscriptions => 1
    )
  end

  it "renders the edit tournament_day form" do
    render

    response.should have_tag("form[action=#{tournament_day_path(@tournament_day)}][method=post]") do
      with_tag('input#tournament_day_tournament_id[name=?]', "tournament_day[tournament_id]")
      with_tag('input#tournament_day_max_inscriptions[name=?]', "tournament_day[max_inscriptions]")
    end
  end
end
