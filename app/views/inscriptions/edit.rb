# encoding: UTF-8

class Views::Inscriptions::Edit < Views::Inscriptions::Inscription
#  needs :tournaments, :inscription
  def page_title
    'Einschreibung ändern'
  end
  
  def menu_items
    menu_item inscription_path(@inscription), "Details anzeigen", eye_image, "anzeigen"
    menu_item inscriptions_path, "Zur Liste der Einschreibungen", list_image, "Liste" if @admin
  end

  def sw_content
    inscription_form "Ändern"
  end

end
