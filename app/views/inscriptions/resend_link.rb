# encoding: UTF-8

class Views::Inscriptions::ResendLink < Views::Inscriptions::Inscription
#  needs :tournaments, :inscription
  def page_title
    t :resend_login_link
  end
  
  def page_menu
  end
  
  def sw_content
    p "Um dir den Login-Link erneut zustellen zu können benötigen wir das betroffene Turnier und deine Email-Adresse."
    p do
      text "Bitte trage diese Informationen im untenstehenden Formular ein und schicke es ab. "
      text "Der Login-Link sollte dann innerhalb weniger Minuten zugestellt werden. "
      text "Falls dies nicht funktioniert, so schicke bitte eine "
      link_to "Email an das Turnier-Team", email_form_path
      text "."
    end
    form_for @inscription, :url => resend_path, id:'resend_link', class:'resend_link' do |f|
      rawtext f.error_messages
      table do
        tr do
          td :class => 'label' do
            rawtext f.label(Views::Labels.label(:tournament_id))
          end
          td do
            rawtext f.collection_select(:tournament_id, @tournaments, :id, :name)
          end
        end
        form_text_field f, :email
      end
      p do
        rawtext f.submit("Link zustellen")
      end
    end
  end
end