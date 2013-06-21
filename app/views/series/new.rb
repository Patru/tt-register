# encoding: UTF-8

class Views::Series::New < Views::Series::Series
  def page_title
    'Neue Serie'
  end

  def menu_items
    list_menu
  end

  def sw_content
    series_form("speichern")
  end
end
