class Views::Series::Players < Views::Layouts::SWPage
  def page_title
    "#{@play_series.size} Anmeldungen für #{@series.long_name}"
  end

  def page_menu
  end

  def sw_content
    table do
      headers :name, :club, :ranking
      @play_series.each do |play_ser|
        tr do
          td play_ser.inscription_player.player.long_name
          td play_ser.inscription_player.player.club
          td :align => "right" do 
            text play_ser.display_ranking
          end
        end
      end
    end
  end
end
