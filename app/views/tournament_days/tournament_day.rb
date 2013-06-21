# encoding: UTF-8

class Views::TournamentDays::TournamentDay < Views::Layouts::SWPage
  @@fields=[:tournament_id, :day, :max_inscriptions]
  def fields
    @@fields
  end
  
  def tournament_day_form(button_text)
    form_for(@tournament_day) do |f|
      rawtext f.error_messages
      table do
        tr do
          td :align => 'right' do
            rawtext f.label(Views::Labels.label(:tournament_id))
          end
          td do
            rawtext f.collection_select(:tournament_id, @tournaments, :id, :name)
          end
        end
        form_date_select f, :day
        form_text_field f, :max_inscriptions
        form_text_field f, :series_per_day
        form_text_field f, :max_single_series
        form_text_field f, :max_double_series
        form_text_field f, :max_age_series
      end
      p do
        rawtext f.submit(button_text)
      end
    end
  end

  def show_menu
    menu_item tournament_day_path(@tournament_day), t('links.show_tournament_day.title'), eye_image, t('links.show_tournament_day.text')
  end

  def edit_menu
    menu_item edit_tournament_day_path(@tournament_day), t('links.edit_tournament_day.title'), stylo_image, t('links.edit_tournament_day.text')
  end

  def list_menu
    menu_item tournament_days_path, t('links.list_tournament_days.title'), list_image, t('links.list_tournament_days.text')
  end

  def new_menu
    menu_item new_tournament_day_path, t('links.new_tournament_day.title'), new_image, t('links.new_tournament_day.text')
  end
end