# encoding: UTF-8
module Views
  module Series
    module Listers
      class Elo14Lister < Lister
        def content
          series_title

          table :class => 'players_list' do
            elo_header
            player_count = @play_series.count
            category_sizes = list_of_sizes player_count, 14

            tbody do
              sum_categories = 0
              category_sizes.each.with_index(0) do |size, index|
                show_index = 1+index
                sum_categories = sum_categories + size
                end_index = sum_categories-1
                start_index = end_index - size + 1
                one_series show_index, @play_series[start_index..end_index]
                if index < category_sizes.count
                  tr do
                    td :class => 'small-vspace' do
                      text ""
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end