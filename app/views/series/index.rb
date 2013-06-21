# encoding: UTF-8

class Views::Series::Index < Views::Series::Series
  def self.default_url_options
    {}
  end
  def page_title
    'Liste der Serien'
  end

  def menu_items
    new_menu
  end

  def sw_content
    widget(Views::Series::List, {:series => @series})
  end
end
