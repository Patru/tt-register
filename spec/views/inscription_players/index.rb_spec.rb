require 'spec_helper'

describe "/inscription_players/index.rb" do
  include InscriptionPlayersHelper

  before(:each) do
    assigns[:inscription_players] = [
      stub_model(InscriptionPlayer,
        :inscription_id => 1,
        :player_id => 1
      ),
      stub_model(InscriptionPlayer,
        :inscription_id => 1,
        :player_id => 1
      )
    ]
  end

  it "renders a list of inscription_players" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
