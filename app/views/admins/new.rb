# encoding: UTF-8

class Views::Admins::New < Views::Layouts::SWPage
  def page_title
    'Neuer Administrator'
  end

  def sw_content
    form_for @admin do |f|
      rawtext f.error_messages
      table do
        form_text_field f, :name
        form_text_field f, :email
        form_text_field f, :token
        form_password_field f, :password
      end
      p do
        rawtext f.submit("Erzeugen")
      end
    end
  end
end