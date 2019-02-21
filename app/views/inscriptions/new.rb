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

  def sw_content
    p t :dear_chap
    p t :thanks_and_purpose, thanks_for_interest: tournament.thanks_for_interest_localized
    h2 t :create_new_inscription
    unless tournament.prohibit_new_accounts
      inscription_form t :create_and_confirm
    end
    help_links
    remark
  end
end