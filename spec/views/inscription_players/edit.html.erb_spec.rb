require 'spec_helper'

describe "/inscription_players/edit.html.erb" do
  include InscriptionPlayersHelper

  before(:each) do
    assigns[:inscription_player] = @inscription_player = stub_model(InscriptionPlayer,
      :new_record? => false,
      :inscription_id => 1,
      :player_id => 1
    )
  end

  it "renders the edit inscription_player form" do
    render

    response.should have_tag("form[action=#{inscription_player_path(@inscription_player)}][method=post]") do
      with_tag('input#inscription_player_inscription_id[name=?]', "inscription_player[inscription_id]")
      with_tag('input#inscription_player_player_id[name=?]', "inscription_player[player_id]")
    end
  end
end
