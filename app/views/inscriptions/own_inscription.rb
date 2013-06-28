# encoding: UTF-8

class Views::Inscriptions::OwnInscription < Views::Inscriptions::Inscription
  def page_title
    t 'title.transfer_inscription_to_player'
  end
  def page_menu
  end
  def sw_content
    form_for(@inscription, :url => transfer_player_path(@inscription_player.id)) do |f|
      f.error_messages
      table do
        form_hidden_field f, :tournament_id, @inscription.tournament.name
        form_hidden_field f, :licence
        form_hidden_field f, :name
        form_text_field f, :email
      end
      input :type => :hidden, :name => :inscription_player_id, :value => @inscription_player.id
      p do
        rawtext f.submit("Einschreibung übertragen und Email zustellen")
      end
    end
  end
end