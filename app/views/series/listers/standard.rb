# encoding: UTF-8
require 'views/basics.rb'

module Views
  module Series
    module Listers
      class Standard < Erector::Widget
        include Views::Basics
        needs :series, :play_series, :open
        def content
          div class:'series-start' do
            text t :series_start, series_start:I18n.localize(@series.day_time, format: :long)
          end
          table class: 'players_list' do
            headers @series.table_headers

            tbody do
              @play_series.each do |play_ser|
                tr do
                  td play_ser.list_name
                  td play_ser.list_club
                  td :align => "right" do
                    text play_ser.display_ranking
                  end
                end
              end
              @open.each do |players|
                list_of_open players
              end
            end
          end
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
    end
  end
end
