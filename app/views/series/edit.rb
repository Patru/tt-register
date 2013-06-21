# encoding: UTF-8

class Views::Series::Edit < Views::Series::Series
  def page_title
    'Seriendaten ändern'
  end
  
  def menu_items
    show_menu
    list_menu
  end

  def sw_content
    series_form("ändern")
  end
end
=begin
  Series series_name:string long_name:string start_time:time min_ranking:integer max_ranking:integer category:string sex:string
=end