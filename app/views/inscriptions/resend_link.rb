# encoding: UTF-8

class Views::Inscriptions::ResendLink < Views::Inscriptions::Inscription
#  needs :tournaments, :inscription
  def page_title
    t :resend_login_link
  end
  
  def page_menu
  end
  
  def sw_content
    p t 'resend_link.intro'
    p do
      text t('resend_link.instruction')
      link_to t('resend_link.email_team'), email_form_path
      text "."
    end
    form_for @inscription, :url => resend_path, id:'resend_link', class:'resend_link' do |f|
      rawtext f.error_messages
      table do
        tr do
          td :class => 'label' do
            rawtext f.label(attribute_label :tournament_id)
          end
          td do
            rawtext f.collection_select(:tournament_id, @tournaments, :id, :name)
          end
        end
        form_text_field f, :email
      end
      p do
        rawtext f.submit(t 'button.send_new_link')
      end
    end
  end
end