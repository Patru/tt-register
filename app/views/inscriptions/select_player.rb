# encoding: UTF-8

class Views::Inscriptions::SelectPlayer < Views::Layouts::SWPage

  def self.default_url_options
    {}
  end
  def page_title
    t :players_for_selection
  end

  def player_row(player, *fields)
    link_player = url_for(:controller => 'inscription_players', :action => 'player', :id => player.id, :only_path => true)
    tr :class => 'select_item', :onclick => "sel_item('#{link_player}')" do
      td do
        a :href => link_player do
          text player.long_name
        end
      end
      data_fields(player, *fields)
    end
  end
      
  def sw_content
    p t :choose_player_and_select_series
    table class: 'players' do
      headers :name, :club, :licence, :ranking, :woman_ranking, :category

      for player in @players do
        player_row player, :club, :licence, :disp_ranking, :disp_woman_ranking, :category
      end
    end
    if @players.size < @player_count then
      p t(:shown_total_players, shown:@players.size, total:@player_count)
    else
      p t(:all_players_shown, count:@players.size)
    end
  end
end
