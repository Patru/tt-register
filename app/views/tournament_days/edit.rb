# encoding: UTF-8

class Views::TournamentDays::Edit < Views::TournamentDays::TournamentDay
  def page_title
    'Turniertag ändern'
  end
  
  def menu_items
    show_menu
    list_menu
  end

  def sw_content
    tournament_day_form "Ändern"
  end

end
