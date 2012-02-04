class Views::InscriptionPlayers::NewPlayer < Views::InscriptionPlayers::InscriptionPlayer
#  needs :player, :inscription, :inscription_player => nil
  
  def page_title
    "Neue Anmeldung zum #{tournament.name}"
  end
  def page_menu
  end
  
  def sw_content
    form_tag(:controller => 'inscription_players', :action => 'enroll') do
      rawtext error_messages_for(:inscription_player,
                                 :header_message => "Fehler beim speichern", :message => "Folgende Probleme sind aufgetreten:")
      if @sel_series then
        sel_series = @sel_series
      else
        sel_series = []
      end
      widget tournament.layouter, {:player => @player, :inscription => @inscription, :selected_series => sel_series}
      input :type => "submit", :value => "Anmelden"
    end
  end
end