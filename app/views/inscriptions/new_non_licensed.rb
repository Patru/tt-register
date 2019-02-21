# encoding: UTF-8

class Views::Inscriptions::NewNonLicensed < Views::Inscriptions::Inscription
#  needs :tournaments, :inscription
  def page_title
    t(:non_licensed_registration)
  end
  
  def back_link
  end

  def sw_content
    p t :dear_non_licensed_chap
    p t :non_licensed_thanks, thanks_for_interest: tournament.thanks_for_interest_localized
    p t :non_licensed_how
    h2 t :non_licensed_registration
    unless tournament.prohibit_new_accounts
      inscription_form t :create_and_confirm
    end
    help_links
    remark
  end

  def inscription_form(button_text)
    form_for(@registration, url:non_licensed_registration_path(@registration),
             html:{class:'new_inscription'}) do |f|
      rawtext f.error_messages(:header_message => t(:error_during_creation_of_inscription),
                               :message => t(:the_following_fields_must_be_corrected))
      table do
        tr do
          td :class => 'label' do
            rawtext label_text(f,:tournament_id)
          end
          td do
            rawtext f.collection_select(:tournament_id, @tournaments, :id, :name)
          end
        end
=begin
        if @inscription.new_record? or @admin then
          form_text_field f, :email, {placeholder: 'me@my.host', type: 'email', autofocus:true}
        else
          if @inscription.id.eql? session[:id] then
            form_hidden_field f, :email
          end
        end
=end
   #     form_text_field f, :licence, {placeholder: t(:licence), type: 'number'}
        form_text_field f, :name, {placeholder: t(:name)}
        form_text_field f, :first_name, {placeholder: t(:first_name)}
        form_text_field f, :group, {placeholder: t(:group)}
        form_text_field f, :email, {placeholder: t(:email)}
        form_checkbox_field f, :keep_informed, t(:about_next_event)
      end
      p do
        rawtext f.submit(button_text, id:'create_registration', data: { disable_with: t(:processing) })
      end
    end
  end
end