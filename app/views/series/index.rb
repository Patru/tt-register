class Views::Series::Index < Views::Series::Series
  def self.default_url_options
    {}
  end
  def page_title
    'Liste der Serien'
  end

  def menu_items
    menu_item new_series_path, "Neue Serie erfassen", new_image, "Neue Serie"
  end

  def sw_content
    widget(Views::Series::List, {:series => @series})
  end
end
