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
end