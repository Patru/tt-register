# encoding: UTF-8

class Views::Inscriptions::Index < Views::Inscriptions::Inscription
  def self.default_url_options
    {}
  end
  def page_title
    'Liste der Einschreibungen'
  end

  def menu_items
    menu_item new_inscription_path, "Neue Einschreibung erfassen", new_image, "Neue Einschreibung"
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
          link_to stylo_image, edit_inscription_path(inscription), :title => 'ändern'
        end
        td do
          link_to(lightning_image, inscription, :confirm => 'Ganze Einschreibung löschen?', :method => :delete, :title => 'löschen')
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
