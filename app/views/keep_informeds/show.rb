# encoding: UTF-8

class Views::KeepInformeds::Show < Views::KeepInformeds::KeepInformed
  def page_title
    'Spieler anzeigen'
  end

  def menu_items
 #   edit_menu
  end

  def sw_content
    show_data_table @keep_informed, :email, :unlicensed, :salutation, :language
  end
end
