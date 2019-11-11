# encoding: UTF-8

class Views::Tournaments::ShowKeepInformedEmails < Views::Tournaments::Tournament
  def page_title
    "Emails für #{@tournament.name} anzeigen"
  end

  def menu_items
  end

  def show_menu(keep_informed)
    menu_item_emoji keep_informed_path(keep_informed), :show
  end

  def keep_informed_row(keep_informed)
    tr do
      data_fields(keep_informed, :email, :create_inscription, :salutation, :language)
#      td do
#        a(:href => tournament_path(tournament), :title => "Details anzeigen") do
#          image_tag("show.png", :border=>0)
#        end
#      end
#      td do
#        a(:href => edit_tournament_path(tournament), :title => 'ändern') do
#          image_tag("stylo.png", :border=>0)
#        end
#      endF
      td do
        link_to "\u{1F441}", keep_informed_path(keep_informed), :title => t(:show)
      end
      td do
        link_to "\u{1F4DD}", edit_keep_informed_path(keep_informed), :title => t(:change)
      end
      td do
#        text "löschen"
        link_to(lightning_image, keep_informed, :confirm => 'Wirklich?', :method => :delete)
      end
    end
  end
  
  def sw_content
    if @tournament.keep_informeds.count > 0
      table do
        thead do
          headers :email, :create_inscription, :salutation, :language
        end
        @tournament.keep_informeds.each do |keep_informed|
          keep_informed_row(keep_informed)
        end
      end
    else
      text "Keine E-Mails vorhanden"
    end
    p do
      link_to "Emails herunterladen", download_tournament_emails_path(:id => @tournament.id, :format => "csv")
    end
  end
end

