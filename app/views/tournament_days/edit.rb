# encoding: UTF-8

class Views::TournamentDays::Edit < Views::TournamentDays::TournamentDay
  def page_title
    'Turniertag ändern'
  end
  
  def menu_items
    menu_item tournament_day_path(@tournament_day), "Stammdaten anzeigen", eye_image, "anzeigen"
    menu_item tournament_days_path, "Zur Liste der Turniertage", list_image, "Liste"
  end

  def sw_content
    tournament_day_form "Ändern"
  end

end
