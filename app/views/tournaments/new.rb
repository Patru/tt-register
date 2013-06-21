# encoding: UTF-8

class Views::Tournaments::New < Views::Tournaments::Tournament
  def page_title
    'Neues Turnier'
  end

  def menu_items
    list_menu
  end
  
  def sw_content
    tournament_form "Erzeugen"
  end
end
