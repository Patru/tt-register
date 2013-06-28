# encoding: UTF-8

require 'views/widget/series_box.rb'

class Views::InscriptionPlayers::Show < Views::InscriptionPlayers::InscriptionPlayer
  def page_title
    "Anmeldung zum #{@inscription.tournament.name}"
  end

  def menu_items
    edit_menu
  end

  def sw_content
    widget tournament.layouter, {:player => @player, :inscription => @inscription,
                                 :selected_series => @inscription_player.series,
                                 :inscription_player => @inscription_player}
    inscribed = @inscription_player.inscribed_series
    p "#{t('attributes.inscribed_for')}: #{inscribed}" if inscribed and inscribed.length > 0
    waiting_list
    input :type => "button", :value => t('button.back_to_list'), :onClick =>  "history.go(-2)" if @go_back_to_list
  end
end
