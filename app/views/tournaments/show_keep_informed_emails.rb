# encoding: UTF-8

class Views::Tournaments::ShowKeepInformedEmails < Views::Tournaments::Tournament
  def page_title
    "Emails für #{@tournament.name} anzeigen"
  end

  def menu_items
  end

  def keep_informed_row(keep_informed)
    tr do
      data_fields(keep_informed, :email, :create_inscription)
#      td do
#        a(:href => tournament_path(tournament), :title => "Details anzeigen") do
#          image_tag("show.png", :border=>0)
#        end
#      end
#      td do
#        a(:href => edit_tournament_path(tournament), :title => 'ändern') do
#          image_tag("stylo.png", :border=>0)
#        end
#      end
      td do
        text "löschen"
#        link_to('Löschen', tournament, :confirm => 'Wirklich?', :method => :delete)
      end
    end
  end
  
  def sw_content
    if @tournament.keep_informeds.count > 0
      table do
        thead do
          headers :email, :create_inscription
        end
        @tournament.keep_informeds.each do |keep_informed|
          keep_informed_row(keep_informed)
        end
      end
    else
      text "Keine E-Mails vorhanden"
    end
    p do
      link_to "Anmeldungen herunterladen", tournament_entries_path(:id => @tournament.id, :format => "dbsv")
    end
  end
end

