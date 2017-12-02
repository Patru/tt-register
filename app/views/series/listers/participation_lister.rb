# encoding: UTF-8
require 'views/basics.rb'

module Views
  module Series
    module Listers
      class ParticipationLister < Erector::Widget
        include Views::Basics
        needs :series, :play_series, :open
        def content
          div class:'series-start' do
            text t :series_start, series_start:I18n.localize(@series.day_time, format: :long)
          end

          regulars = @play_series.slice(0,@series.max_participants)
          replacements = @play_series.slice(@series.max_participants, 100)

          table class: 'players_list' do
            headers @series.table_headers

            tbody do
              trs_for regulars
              if replacements != nil && replacements.length > 0
                tr :class => :replacements do
                  td :colspan => 3 do
                    h4 :class => :open_inscriptions do
                      text I18n.t :replacement_players
                    end
                  end
                end
                headers_with_class :replacements, @series.table_headers
                trs_for replacements, {:class => :replacements}
              end
            end
          end
        end

        def trs_for(players, opts={})
          players.each do |play_ser|
            tr opts do
              td play_ser.list_name
              td play_ser.list_club
              td :align => "right" do
                text play_ser.display_ranking
              end
            end
          end
        end
      end
    end
  end
end
