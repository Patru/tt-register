# encoding: UTF-8

class Views::Players::Edit < Views::Players::Player
  def page_title
    t(:change_player_data)
  end

  def menu_items
    show_menu
    list_menu
  end

  def sw_content
    player_form t(:change)
  end

end
