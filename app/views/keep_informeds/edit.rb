# encoding: UTF-8

class Views::KeepInformeds::Edit < Views::KeepInformeds::KeepInformed
  def page_title
    t(:change_email_data)
  end

  def menu_items
    show_menu
    list_menu
  end

  def sw_content
    keep_informed_form t(:change)
  end

end
