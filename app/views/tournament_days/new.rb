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
    list_menu
  end
  def sw_content
    tournament_day_form "Erzeugen"
  end
end
