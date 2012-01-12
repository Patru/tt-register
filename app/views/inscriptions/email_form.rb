class Views::Inscriptions::EmailForm < Views::Inscriptions::Inscription
#  needs :tournaments, :inscription
  def page_title
    'Email ans Team senden'
  end
  
  def page_menu
  end
  
  def sw_content
    p "Mit diesem Formular kannst uns Anregungen, Probleme, Kritiken oder auch einfach Lob zustellen."
    form_for @email, :url => mail_team_path do |f|
      rawtext f.error_messages
      hidden_field_tag( "tournament_id", tournament.id)
      #rawtext f.hidden_field(:tournament_id, tournament.id)
      table do
        form_text_field f, :from
        form_text_field f, :subject
        form_text_area  f, :text
      end
      p do
        rawtext f.submit("Email abschicken")
      end
    end
  end
end