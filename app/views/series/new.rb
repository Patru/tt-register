class Views::Series::New < Views::Series::Series
  def page_title
    'Neue Serie'
  end

  def menu_items
    menu_item url_for(:controller=>"series", :action=>"index", :only_path=>true), "Liste der Serien", new_image, "Liste"
  end

  def sw_content
    series_form("speichern")
  end
end
