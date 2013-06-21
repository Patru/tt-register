# encoding: UTF-8

class Views::Tournaments::Edit < Views::Tournaments::Tournament
  def page_title
    'Turnierdaten ändern'
  end
  
  def menu_items
    show_menu
    list_menu
  end

  def sw_content
    tournament_form "Ändern"
  end
end
