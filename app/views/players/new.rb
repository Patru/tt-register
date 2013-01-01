# encoding: UTF-8

class Views::Players::New < Views::Players::Player
  def page_title
    'Neuer Spieler'
  end

  def menu_items
    menu_item players_path, "Zur Liste der Spieler", list_image, "Liste"
  end
  def sw_content
    player_form "Erzeugen"
  end
end
