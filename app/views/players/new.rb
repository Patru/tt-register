# encoding: UTF-8

class Views::Players::New < Views::Players::Player
  def page_title
    'Neuer Spieler'
  end

  def menu_items
    list_menu
  end

  def sw_content
    player_form "Erzeugen"
  end
end
