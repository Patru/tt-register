# encoding: UTF-8
require_relative 'lister'

module Views
  module Series
    module Listers
      class Elo18Lister < Lister
        def content
          series_title

          table class: 'players_list' do
            elo_header
            pl_count = @play_series.count.to_f
            category_sizes = sizes_list pl_count

            tbody do
              sum_categories = 0
              category_sizes.each.with_index(1) do |size, index|
                sum_categories = sum_categories + size
                end_index = sum_categories-1
                start_index = end_index - size + 1
                one_series index, @play_series[start_index..end_index]
                if index < category_sizes.count
                  tr do
                    td class:'small-vspace' do
                      text ""
                    end
                  end
                end
              end
            end
          end
        end

        def straight_list(n, parts)
          larger_size = (n.to_f/parts).ceil
          larger_count = n%parts
          if larger_count == 0
            larger_count = parts
            smaller_count = 0
          else
            smaller_count = parts-larger_count
          end
          Array.new(larger_count, larger_size)+Array.new(smaller_count, larger_size-1)
        end

        def sizes_list(n)
          number_of_categories = (n/18.0).ceil
          dist = n
          parts = number_of_categories
          list = straight_list(dist, parts)
          twelves = []
          loop do
            dist = dist - 12
            parts = parts - 1
            new_list = straight_list(dist, parts)
            if new_list[0] > 18
              return list + twelves
            else
              list = new_list
              twelves << 12
            end
          end
        end
      end
    end
  end
end
