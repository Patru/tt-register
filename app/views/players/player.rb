# encoding: UTF-8

class Views::Players::Player < Views::Layouts::SWPage
  def player_form(button_text)
    labeled_table_form @player, [:licence, :name, :first_name, :club, :ranking, :woman_ranking, :category, :rank, :woman_rank], button_text
  end
end