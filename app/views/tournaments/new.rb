class Views::Tournaments::New < Views::Tournaments::Tournament
  def page_title
    'Neues Turnier'
  end

  def menu_items
    menu_item tournaments_path, "Zur Liste der Turniere", new_image, "Liste"
  end
  
  def sw_content
    tournament_form "Erzeugen"
  end
end
