class Views::Tournaments::Tournament < Views::Layouts::SWPage
  @@table_fields=[:tour_id, :name, :date, :organiser]
  @@fields = @@table_fields.clone
  @@fields << :info_link
  @@fields << :logo
  @@fields << :stylesheet
  def fields
    @@fields
  end
  def table_fields
    @@table_fields
  end
  
  def tournament_form(button_text)
    labeled_table_form @tournament, fields, button_text
  end
end