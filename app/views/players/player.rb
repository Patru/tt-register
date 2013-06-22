# encoding: UTF-8

class Views::Players::Player < Views::Players::Player
  def player_form(button_text)
    labeled_table_form @player, [:licence, :name, :first_name, :club, :ranking, :woman_ranking, :category, :rank, :woman_rank], button_text
  end

  def show_menu
    menu_item player_path(@player), :show_player, eye_image unless is_admin?
  end

  def list_menu
    menu_item players_path, :list_players, list_image
  end

  def new_menu
    menu_item new_player_path, :new_player, new_image
  end

  def edit_menu
    menu_item edit_player_path(@player), :edit_player, stylo_image
  end
end