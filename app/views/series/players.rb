# encoding: UTF-8
require 'views/series/listers/all'

class Views::Series::Players < Views::Layouts::SWPage
#  needs :series, :play_series, :open   #not sure we can have :inscription in here, kind of optional
  def page_title
    t('title.inscriptions_for', number:@play_series.size, series_name:@series.translated_name)
  end

  def lister
    make_class(:Views, :Series, :Listers, @series.lister)
  end

  def sw_content
    widget lister, {series: @series, play_series: @play_series, open:@open}
  end

  def list_of_open players
    tr do
      td :span => 3 do
        h4 :class => :open_inscriptions do
          text players.title
        end
      end
    end
    headers :name, :club, :ranking
    players.play_sers.each do |play_ser|
      tr do
        td play_ser.list_name
        td play_ser.list_club
        td :align => "right" do
          text play_ser.ranking
        end
      end
    end
  end
end
