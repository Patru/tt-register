class Views::Tournaments::Edit < Views::Tournaments::Tournament
  def page_title
    'Turnierdaten ändern'
  end
  
  def menu_items
    menu_item tournament_path(@tournament), "Stammdaten anzeigen", eye_image, "anzeigen"
    menu_item tournaments_path, "Zur Liste der Turniere", list_image, "Liste"
  end

  def sw_content
    tournament_form "Ändern"
  end
end
