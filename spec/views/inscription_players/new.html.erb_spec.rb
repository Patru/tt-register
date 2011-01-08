require 'spec_helper'

describe "/inscription_players/new.html.erb" do
  include InscriptionPlayersHelper

  before(:each) do
    assigns[:inscription_player] = stub_model(InscriptionPlayer,
      :new_record? => true,
      :inscription_id => 1,
      :player_id => 1
    )
  end

  it "renders new inscription_player form" do
    render

    response.should have_tag("form[action=?][method=post]", inscription_players_path) do
      with_tag("input#inscription_player_inscription_id[name=?]", "inscription_player[inscription_id]")
      with_tag("input#inscription_player_player_id[name=?]", "inscription_player[player_id]")
    end
  end
end
