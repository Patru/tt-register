require 'spec_helper'

describe "/inscription_players/show.rb" do
  include InscriptionPlayersHelper
  before(:each) do
    assigns[:inscription_player] = @inscription_player = stub_model(InscriptionPlayer,
      :inscription_id => 1,
      :player_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
