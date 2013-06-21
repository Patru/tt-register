# encoding: UTF-8

class Views::Static::Help < Views::Layouts::SWPage
  def page_title
    t(:help)
  end

  def sw_content
    root_link=capture_content do
      link_to t(:root_page), root_path
    end
    p do
      rawtext t(:help_para1, tournament_name: tournament.name, start_html: root_link)
    end
    p do
      text t(:help_para2)
    end
    login_link=capture_content do
      link_to t(:new_login_link), resend_link_path
    end
    p do
      rawtext t(:help_para3, new_login_link: login_link)
    end
    p do
      text t(:help_para4)
    end
    mail_team_link = capture_content do
      link_to t(:mail_team), email_form_path
    end
    p do
      rawtext t(:help_para5, email_link: mail_team_link)
    end
    create_link=capture_content do
      link_to t(:create_inscription_form), root_path
    end
    p do
      rawtext t(:help_create_inscription, create_inscription_link:create_link)
    end
  end
end