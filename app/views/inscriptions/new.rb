# encoding: UTF-8

class Views::Inscriptions::New < Views::Inscriptions::Inscription
#  needs :tournaments, :inscription
  def page_title
    t :new_inscription
  end
  
  def back_link
    if valid_inscription
      my_inscription_link
    end
  end

  def help_links
    ul id:'help_links' do
      li {link_to t(:help), static_path(:help)}
      li {link_to t(:lost_login_link), resend_link_path}
      li {link_to t(:privacy), protection_path}
      li {link_to t(:mail_team), email_form_path}
    end
  end
  
  def sw_content
    p t :dear_chap
    p t :thanks_and_purpose, thanks_for_interest: tournament.thanks_for_interest_localized
    h2 t :create_new_inscription
    inscription_form t :create_and_confirm
    help_links
  end
end