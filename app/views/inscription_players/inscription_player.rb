# encoding: UTF-8

class Views::InscriptionPlayers::InscriptionPlayer < Views::Layouts::SWPage
  
  def inscription_form(button_text)
    form_for(@inscription) do |f|
      rawtext f.error_messages
      table do
        tr do
          td :align => 'right' do
            f.label(Views::Labels.label(:tournament_id))
          end
          td do
            f.collection_select :tournament_id, @tournaments, :id, :name
          end
        end
        form_text_field f, :licence
        form_text_field f, :name
        form_text_field f, :email
      end
      p do
        f.submit(button_text)
      end
    end
  end
  
  def waiting_list
    return unless @inscription_player.waiting_list_entries.length > 0
    @inscription_player.waiting_list_entries.each do |waiting_day|
      p "Warteliste #{waiting_day.tournament_day.day_name}: #{waiting_day.series_list}; aktuell Nummer #{waiting_day.number_in_list} auf der Liste"
    end
  end

  def show_menu
    menu_item inscription_player_path(@inscription_player), t('links.show_inscription_player.title'), eye_image, t('links.show_inscription_player.text') unless @inscription_player.new_record?
  end

  def edit_menu
    menu_item edit_inscription_player_path(@inscription_player), t('links.edit_inscription_player.title'), stylo_image, t('links.edit_inscription_player.text')
  end

  def list_menu
    menu_item inscription_players_path, t('links.list_inscription_players.title'), list_image, t('links.list_inscription_players.text')
  end

  def new_menu
    menu_item new_tournament_path, t('links.new_inscription_player.title'), new_image, t('links.new_inscription_player.text')
  end
end