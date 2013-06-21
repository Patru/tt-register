# encoding: UTF-8

require 'views/widget/series_box.rb'

class Views::InscriptionPlayers::Edit < Views::InscriptionPlayers::InscriptionPlayer
  def page_title
    "Änderung der Anmeldung von #{@inscription_player.player.long_name}"
  end

  def menu_items
    show_menu
  end

  def sw_content
    form_tag :controller => 'inscription_players', :action => 'update_series' do
      rawtext error_messages_for(:inscription_player, :header_message => "Fehler beim speichern",
                                 :message => "Folgende Probleme sind aufgetreten:")
      widget tournament.layouter, {:player => @inscription_player.player,
                                   :inscription => @inscription_player.inscription,
                                   :selected_series => @inscription_player.series,
                                   :inscription_player => @inscription_player}
      tr do
        td {}
        td do
          input :type => "submit", :value => "Ändern"
        end
      end
    end
    button_to("Abmelden",  @inscription_player, :method => :delete,
        :confirm => "Soll #{@inscription_player.player.long_name} wirklich abgemeldet werden?") unless @inscription_player.new_record?
    waiting_list
  end
end
