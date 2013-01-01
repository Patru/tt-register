# encoding: UTF-8

class Views::TournamentDays::New < Views::TournamentDays::TournamentDay
#  needs :tournaments, :tournament_day
  def page_title
    'Neuer Turniertag'
  end
  def page_menu
    menu_list
  end
  def menu_items
    menu_item tournament_days_path, "Zur Liste der Turniertage", list_image, "Liste der Tage"
  end
  def sw_content
    tournament_day_form "Erzeugen"
  end
end
