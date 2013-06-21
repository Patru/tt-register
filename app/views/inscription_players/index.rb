# encoding: UTF-8

class Views::InscriptionPlayers::Index < Views::InscriptionPlayers::InscriptionPlayer
  def self.default_url_options
    {}
  end
  def page_title
    'Liste der Anmeldungen'
  end

  def inscription_row(inscription_player)
    tr do
      td do
        text inscription_player.inscription.name
      end
      td do
        text inscription_player.player.first_name 
        text " "
        text inscription_player.player.name
      end
      td do
        text inscription_player.player.club
      end
      td do
        link_to(eye_image, inscription_player, :title => "Details anzeigen")
      end
      td do
        link_to stylo_image, edit_inscription_player_path(inscription_player), :title => t(:change)
      end
      td do
        link_to(lightning_image, inscription_player, :confirm => 'Wirklich?', :method => :delete, :title => 'abmelden')
      end
    end
  end
    
  def sw_content
    table do
      tr do
        th do
          text "eingeschrieben von"
        end
        th do
          text "Spieler"
        end
        th do
          text "Club"
        end
      end

      for inscription_player in @inscription_players do
        inscription_row inscription_player
      end
    end
    p do
      link_to 'Neue Anmeldung', new_inscription_player_path
    end
  end
end
