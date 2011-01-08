class Views::Series::Show < Views::Layouts::SWPage
  def page_title
    'Serie anzeigen'
  end

  def menu_items
    menu_item edit_series_path(@series), "Seriendaten ändern", stylo_image, "ändern"
  end
  
  def sw_content
    table do 
      labeled_data(:tournament_day_id, @series.tournament_day.display_name)
      [:series_name, :long_name, :start_time_text, :min_ranking, :max_ranking, :category, :sex, :use_rank].each do |field|
        show_data_item(@series, field)
      end
    end
  end
end
