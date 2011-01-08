require 'views/tables.rb'

class Views::Series::List < Erector::Widget
  include Views::Tables
#  needs :series
  
  @@columns = [:tournament_day_id, :series_name, :long_name, :start_time, :min_ranking, :max_ranking, :category, :sex]

  def initialize(helpers=nil, assigns={}, output = "", &block)
    super(helpers, assigns, output)
  end

  def self.default_url_options
    {}
  end
  def row(series)
    tr do
      td do
        text series.tournament_day.short_display
      end
      data_fields(series, [:series_name])
      td do
        link_to(series.long_name, series)
      end
      td do
        text series.start_time_text
      end
      data_fields(series, [:min_ranking, :max_ranking, :category, :sex])
      td do
        link_to(eye_image, series, :title => "Details anzeigen")
      end
      td do
        link_to stylo_image, edit_series_path(series), :title => 'ändern'
      end
      td do
        link_to(lightning_image, series, :confirm => 'Wirklich?', :method => :delete, :title => 'löschen')
      end
    end
  end
  
  def render
    table do
      headers @@columns
      for series in @series do
        row series
      end
    end
  end
end