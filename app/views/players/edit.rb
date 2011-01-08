class Views::Players::Edit < Views::Players::Player
  def page_title
    'Spielerdaten ändern'
  end

  def menu_items
    menu_item player_path(@player), "Stammdaten anzeigen", eye_image, "anzeigen"
    menu_item players_path, "Liste der Spieler", list_image, "Liste"
  end

  def sw_content
    player_form "Ändern"
  end

end
