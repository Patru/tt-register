# encoding: UTF-8

class Views::Admins::Login < Views::Layouts::SWPage
  def page_title
    'Login für Administratoren'
  end

  def sw_content
    form_for @admin, :url => url_for(:controller => 'admins', :action => 'verify_login', :only_path => true) do |f|
      rawtext f.error_messages
      table do
        show_data_item @admin, :name
        rawtext f.hidden_field(:token)
        form_password_field f, :password, autofocus:true
      end
      p do
        rawtext f.submit("Anmelden")
      end
    end
  end
end