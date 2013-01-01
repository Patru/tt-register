# encoding: UTF-8

class Views::Players::Show < Views::Layouts::SWPage
  def page_title
    'Spieler anzeigen'
  end

  def menu_items
    menu_item edit_player_path(@player), 'Diesen Spieler ändern', stylo_image, "ändern"
  end
  
  def sw_content
    show_data_table @player, :name, :first_name, :club, :licence, :disp_ranking, :disp_woman_ranking, :category
  end
end
