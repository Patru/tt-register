# encoding: UTF-8

class Views::Inscriptions::Index < Views::Inscriptions::Inscription
  def self.default_url_options
    {}
  end
  def page_title
    'Liste der Anmeldekonti'
  end

  def menu_items
    new_inscription_menu
  end

  def inscription_row(inscription, *fields)
    tr do
      td do
        text inscription.tournament.name
      end
      data_fields(inscription, *fields)
      td do
        if @admin or inscription.id == session[:id] then
          text inscription.email
        else
          text "**@***.**"
        end
      end
      td do
        link_to(eye_image, inscription, :title => "Details anzeigen")
      end
      if @admin or inscription.id == session[:id] then
        td do
          link_to stylo_image, edit_inscription_path(inscription), :title => t(:change)
        end
        td do
          link_to(lightning_image, inscription, confirm: t('confirm.delete_inscription'), :method => :delete, :title => 'löschen')
        end
      end
    end
  end
    
  def sw_content
    table do
      headers header_fields

      for inscription in @inscriptions do
        inscription_row inscription, fields
      end
    end
  end
end
