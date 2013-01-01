# encoding: UTF-8

class Views::Series::Edit < Views::Series::Series
  def page_title
    'Seriendaten ändern'
  end
  
  def menu_items
    menu_item series_path(@series), "Details zur Serie", eye_image, "anzeigen"
    menu_item url_for(:controller=>"series", :action=>"index", :only_path=>true), "Zur Liste der Serien", list_image, "Liste"
  end

  def sw_content
    series_form("ändern")
  end
end
=begin
  Series series_name:string long_name:string start_time:time min_ranking:integer max_ranking:integer category:string sex:string
=end