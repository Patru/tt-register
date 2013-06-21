# encoding: UTF-8

class Views::Tournaments::Index < Views::Tournaments::Tournament
  def self.default_url_options
    {}
  end
  def page_title
    'Liste der Turniere'
  end

  def menu_items
    new_menu
  end

  def tournament_row(tournament)
    tr do
      data_fields(tournament, table_fields)
      td do
        a(:href => tournament_path(tournament), :title => "Details anzeigen") do
          image_tag("show.png", :border=>0)
        end
      end
      td do
        a(:href => edit_tournament_path(tournament), :title => 'ändern') do
          image_tag("stylo.png", :border=>0)
        end
      end
      td do
        link_to('Löschen', tournament, :confirm => 'Wirklich?', :method => :delete)
      end
    end
  end
    
  def sw_content
    table do
      headers table_fields

      for tournament in @tournaments do
        tournament_row tournament
      end
    end
  end
end
