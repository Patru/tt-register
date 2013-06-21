# encoding: UTF-8

class Views::Players::Player < Views::Players::Player
  def player_form(button_text)
    labeled_table_form @player, [:licence, :name, :first_name, :club, :ranking, :woman_ranking, :category, :rank, :woman_rank], button_text
  end

  def show_menu
    menu_item player_path(@player), t('links.show_player.title'), eye_image, t('links.show_player.text') unless is_admin?
  end

  def list_menu
    menu_item players_path, t('links.list_players.title'), list_image, t('links.list_players.text')
  end

  def new_menu
    menu_item new_player_path, t('links.new_player.title'), new_image, t('links.new_player.text')
  end

  def edit_menu
    menu_item edit_player_path(@player), t('links.edit_player.title'), stylo_image, t('links.edit_player.text')
  end
end