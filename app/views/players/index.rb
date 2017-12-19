# encoding: UTF-8

require 'action_view/helpers/form_tag_helper'
class Views::Players::Index < Views::Players::Player
  def self.default_url_options
    {}
  end
  def page_title
    'Liste der Spieler'
  end

  def menu_items
    new_menu
  end

  def player_row(player, *fields)
    tr do
      data_fields(player, *fields)
      td do
        a(:href => player_path(player), :title => "Details anzeigen") do
          image_tag("show.png", :border=>0)
        end
      end
      td do
        a(:href => edit_player_path(player), :title => 'ändern') do
          image_tag("stylo.png", :border=>0)
        end
#       rawtext link_to('Ändern', edit_player_path(player))
      end
      td do
        rawtext link_to(lightning_image, player, :confirm => 'Wirklich?', :method => :delete)
      end
    end
  end
  
  def filter_row
    form_for(@filter_cond, :as =>:filter_cond,  :url => url_for(:controller => "players", :action => "filtered", :only_path => true)) do |f|
      tr do
        td do
          rawtext f.text_field(:name, :size => 12)
        end
        td do
          rawtext f.text_field(:first_name, :size => 12)
        end
        td do
          rawtext f.text_field(:club, :size => 12)
        end
        td :colspan=>4 do
        end
        td :colspan=>3 do
          rawtext f.submit("filtern")
        end
      end
    end
  end
    
  def sw_content
    table do
      headers :name, :first_name, :club, :licence, :ranking, :woman_ranking, :elo, :category
      filter_row

      for player in @players do
        player_row player, :name, :first_name, :club, :licence, :disp_ranking, :disp_woman_ranking, :elo, :category
      end
    end
    p do
      text " Insgesamt #{@player_count} Spieler in der Selektion"
      form_tag  url_for(:controller => 'players', :action => 'upload', :only_path => true),
                :method => "post",id: 'upload', :enctype => "multipart/form-data" do
        label "STT Spieler mit Daten aus Datei ersetzen", :for => :file_players
        input :type => :file, :name => :players, :accept => "csv"
        br
        input :type => :checkbox, :name => :delete_not_sent_players
        label "Nicht vorhandene Spieler löschen", :for => :delete_not_sent_players
        br
        submit_tag "Senden" #input :type => :submit, :value => "Senden"
      end
    end
  end
end
