# encoding: UTF-8

class Views::Series::Show < Views::Series::Series
  def page_title
    'Serie anzeigen'
  end

  def menu_items
    edit_menu
  end
  
  def sw_content
    table do 
      labeled_data(:tournament_day_id, @series.tournament_day.display_name)
      [:series_name, :long_name, :start_time_text, :min_ranking, :max_ranking, :min_elo, :max_elo,
       :category, :non_licensed_start, :sex, :use_rank, :type, :max_participants].each do |field|
        show_data_item(@series, field)
      end
    end
  end
end
