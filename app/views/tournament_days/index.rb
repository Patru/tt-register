# encoding: UTF-8

class Views::TournamentDays::Index < Views::TournamentDays::TournamentDay
  def self.default_url_options
    {}
  end
  def page_title
    'Liste der Turniertage'
  end

  def menu_items
    menu_item new_tournament_day_path, "Neuer Turniertag", new_image, "Neuer Turniertag"
  end

  def tournament_day_row(tournament_day)
    tr do #  @@fields=[:tournament_id, :day, :max_inscriptions]
      td tournament_day.tournament.name
      td tournament_day.day
      td :align => "right" do
        text tournament_day.max_inscriptions
      end
      td :align => "right" do
        text tournament_day.count_entries
      end
      td do
        link_to(eye_image, tournament_day, :title => "Details anzeigen")
      end
      td do
        link_to stylo_image, edit_tournament_day_path(tournament_day), :title => 'ändern'
      end
      td do
        link_to(lightning_image, tournament_day, :confirm => 'Wirklich?', :method => :delete, :title => 'löschen')
      end
    end
  end
  
  def header
    tr do
      th "Turnier"
      th "Tag"
      th :colspan => 2 do
        text "Einschreibungen"
      end
      th :colspan => 3 do
        text "Aktionen"
      end
    end
    tr do
      th ""
      th ""
      th "Max"
      th "aktuell"
    end
  end
    
  def sw_content
    table do
      header
      @tournament_days.each do |tournament_day|
        tournament_day_row tournament_day
      end
    end
  end
end
