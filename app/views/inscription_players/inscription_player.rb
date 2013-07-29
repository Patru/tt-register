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
        f.submit(button_text, data: { disable_with: t(:processing) })
      end
    end
  end
  
  def waiting_list
    return unless @inscription_player.waiting_list_entries.length > 0
    @inscription_player.waiting_list_entries.each do |waiting_day|
      p t('waiting_list.full', day:waiting_day.tournament_day.day_name, series: waiting_day.series_list,
          number: waiting_day.number_in_list)
    end
  end

  def show_menu
    menu_item inscription_player_path(@inscription_player), :show_inscription_player, eye_image
  end

  def edit_menu
    menu_item edit_inscription_player_path(@inscription_player), :edit_inscription_player, stylo_image
  end

  def list_menu
    menu_item inscription_players_path, :list_inscription_players, list_image
  end

  def new_menu
    menu_item new_tournament_path, :new_inscription_player, new_image
  end
end