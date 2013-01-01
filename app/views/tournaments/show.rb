# encoding: UTF-8

class Views::Tournaments::Show < Views::Tournaments::Tournament
  def page_title
    "Details für #{@tournament.name} anzeigen"
  end

  def menu_items
    menu_item edit_tournament_path(@tournament), "Turnier ändern", stylo_image, "ändern"
  end
  
  def sw_content
    show_data_table @tournament, fields
    p do
      link_to "Einschreibungen herunterladen", tournament_entries_path(:id => @tournament.id, :format => "dbsv")
      text " | "
      link_to "Einschreibungen löschen", delete_all_inscriptions_path(:id => @tournament.id), :confirm => "Alle Einschreibungen löschen?"
    end
  end
end

