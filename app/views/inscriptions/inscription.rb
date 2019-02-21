# encoding: UTF-8

class Views::Inscriptions::Inscription < Views::Layouts::SWPage
  @@fields=[:licence, :name]
  def fields
    @@fields
  end
  @@header_fields = [:tournament].concat @@fields
  @@header_fields << :email
  def header_fields
    @@header_fields
  end

  def help_links
    ul id:'help_links' do
      li {link_to t(:help), static_path(:help)}
      li {link_to t(:lost_login_link), resend_link_path}
      li {link_to t(:privacy), protection_path}
      li {link_to t(:mail_team), email_form_path}
      if tournament.non_licensed_series?
        li {link_to t(:non_licensed_registration), new_non_licensed_path}
      end
    end
  end

  def inscription_form(button_text)
    form_for(@inscription) do |f|
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
        if @inscription.new_record? or @admin then
          form_text_field f, :email, {placeholder: 'me@my.host', type: 'email', autofocus:true}
        else
          if @inscription.id.eql? session[:id] then
            form_hidden_field f, :email
          end
        end
        form_text_field f, :licence, {placeholder: t(:licence), type: 'number'}
        form_text_field f, :name, {placeholder: t(:first_name_name)}
        form_checkbox_field f, :keep_informed, t(:about_next_event)
      end
      p do
        rawtext f.submit(button_text, id:'create_inscription', data: { disable_with: t(:processing) })
      end
    end
  end

  def see_email?
    own_inscription? or (defined?(@admin) and @admin)
  end

  def own_inscription?
    @inscription and @inscription.id == session[:id]
  end

  def list_menu
    menu_item inscriptions_path, :list_inscriptions, list_image
  end

  def show_menu
    menu_item inscription_path(@inscription), :show_inscription, eye_image
  end

  def new_inscription_menu
    menu_item new_inscription_path, :new_inscription, new_image
  end

  def edit_menu
    menu_item edit_inscription_path(@inscription), :edit_inscription, stylo_image
  end

  def remark
    unless tournament.remark_localized.blank?
      div id:'remark' do
        h2 t(:remark)
        p tournament.remark_localized
      end
    end
  end
end