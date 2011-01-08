class Views::Inscriptions::SelectPlayer < Views::Layouts::SWPage

  def self.default_url_options
    {}
  end
  def page_menu
  end
  def page_title
    'Spieler für Auswahl'
  end

  def player_row(player, *fields)
    link_player = url_for(:controller => 'inscription_players', :action => 'player', :id => player.id, :only_path => true)
    tr :class => 'select_item', :onclick => "sel_item('#{link_player}')" do
      td do
        a :href => link_player do
          text player.long_name
        end
      end
      data_fields(player, *fields)
    end
  end
      
  def sw_content
    p do
      text "Bitte einen Spieler für die Anmeldung auswählen, anschliessend die Serien auswählen und die Anmeldung bestätigen."
    end
    table do
      headers :name, :club, :licence, :ranking, :woman_ranking, :category

      for player in @players do
        player_row player, :club, :licence, :disp_ranking, :disp_woman_ranking, :category
      end
    end
    if @players.size < @player_count then
      p "#{@players.size} angezeigt, #{@player_count} Spieler in aktueller Selektion ."
    else
      p "#{@players.size} Spieler angezeigt"
    end
  end
end
