# encoding: UTF-8

class Views::TournamentDays::WaitingList < Views::TournamentDays::TournamentDay
  def self.default_url_options
    {}
  end
  def page_title
    "Einträge auf der Warteliste vom #{@tournament_day.day.strftime("%A")}"
  end

  def menu_items
  end

  def waiting_list_entry_row index, entry
    tr do
      td "#{index+1}."
      td entry.inscription_player.player.name
      td entry.inscription_player.player.first_name
      td entry.inscription_player.player.club
      td entry.inscription_player.player.elo
      td entry.inscription_player.inscription.name
      td entry.inscription_player.inscription.email
      td entry.created_at.strftime("%Y-%m-%d %H:%M")
    end
  end

  def header
    tr do
      th "Nr"
      th "Name"
      th "Vorname"
      th "Club"
      th "Elo"
      th "Angemeldet von"
      th "E-Mail"
      th "gemeldet am"
    end
  end

  def sw_content
    table do
      header
      @waiting_list_entries.each_with_index do |waiting_list_entry, index|
        waiting_list_entry_row index, waiting_list_entry
      end
    end
  end

end