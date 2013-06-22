# encoding: UTF-8

class Views::Inscriptions::Edit < Views::Inscriptions::Inscription
#  needs :tournaments, :inscription
  def page_title
    'Einschreibung ändern'
  end
  
  def menu_items
    show_menu
    list_menu  if @admin
  end

  def sw_content
    inscription_form "Ändern"
  end

end
