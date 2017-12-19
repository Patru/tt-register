# encoding: UTF-8
require 'views/basics.rb'

module Views
  module Series
    module Listers
      class Lister < Erector::Widget
        include Views::Basics
        needs :series, :play_series, :open

        def series_title
          div class:'series-start' do
            text t :series_start, series_start:I18n.localize(@series.day_time, format: :long)
            unless @series.sys_exp_link.nil?
              text "; "
              a href:@series.sys_exp_link, target:'_blank' do
                text t :system_explanation
              end
            end
          end
        end

        def elo_header
          thead do
            tr do
              th column_header(:name)
              th column_header(:club)
              th column_header(:elo)
              th colspan:2 do
                text column_header(:prov_cat)
              end
            end
          end
        end

        def one_series ser_index, players
          max=players.count
          half=(max-1)/2
          players.each_with_index do |player, idx|
            tr line_opts(idx, half, max-1) do
              td player.list_name
              td player.list_club
              td do
                text player.display_ranking
              end
              td class:'spacer'do
                rawtext '&zwnj;'.html_safe
              end
              if idx ==half
                td class:'series-name' do
                  text I18n.t('players.series_name', index:ser_index, count:players.count)
                end
              else
                td ' '
              end
            end
          end
        end

        def line_opts index, half, last
          if index == 0
            {class:'first'}
          elsif index ==last
            {class:'last'}
          else
            {class:'in'}
          end
        end
      end
    end
  end
end
