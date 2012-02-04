require 'views/widget/series_box.rb'

class Views::InscriptionPlayers::Show < Views::InscriptionPlayers::InscriptionPlayer
  def page_title
    "Anmeldung zum #{@inscription.tournament.name}"
  end

  def menu_items
    menu_item edit_inscription_player_path(@inscription_player), 'Anmeldung ändern', stylo_image, "ändern"
  end
  
  def sw_content
    widget tournament.layouter, {:player => @player, :inscription => @inscription,
                                 :selected_series => @inscription_player.series,
                                 :inscription_player => @inscription_player}
    inscribed = @inscription_player.inscribed_series
    p "angemeldet für: #{inscribed}" if inscribed and inscribed.length > 0
    waiting_list
    input :type => "button", :value => "Zurück zur Liste", :onClick =>  "history.go(-2)" if @go_back_to_list
  end
end
