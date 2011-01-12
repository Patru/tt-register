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
      end
      p do
        rawtext f.submit(button_text)
      end
    end
  end
end