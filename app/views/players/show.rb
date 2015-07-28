# encoding: UTF-8

class Views::Players::Show < Views::Players::Player
  def page_title
    'Spieler anzeigen'
  end

  def menu_items
    edit_menu
  end

  def sw_content
    show_data_table @player, :name, :first_name, :club, :licence, :disp_ranking,
                    :disp_woman_ranking, :category, :elo, :canton, :rv
  end
end
