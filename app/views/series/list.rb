# encoding: UTF-8

require 'views/tables.rb'

class Views::Series::List < Erector::Widget
  include Views::Tables
#  needs :series
  
  @@columns = [:tournament_day_id, :series_name, :long_name, :start_time, :min_ranking, :max_ranking, :category, :sex]

  def initialize(assigns={}, &block)
    super(assigns)
  end

  def self.default_url_options
    {}
  end
  def row(series)
    tr do
      td do
        unless series.tournament_day.nil?
          text series.tournament_day.short_display
        else
          text "deleted"
        end
      end
      data_fields(series, [:series_name])
      td do
        link_to(series.long_name, series_path(series))
          # do not use variable in link_to to avoid polymorphism problemx
      end
      td do
        text series.start_time_text
      end
      td :align => "right" do
        text series.min_ranking
      end
      data_fields(series, [:max_ranking, :category, :sex])
      td do
        link_to(eye_image, series_path(series), :title => "Details anzeigen")
      end
      td do
        link_to stylo_image, edit_series_path(series), :title => 'ändern'
      end
      td do
        link_to(lightning_image, series_path(series), :confirm => 'Wirklich?', :method => :delete, :title => 'löschen')
      end
    end
  end
  
  def content
    table class:'series-list' do
      headers @@columns
      for series in @series do
        row series
      end
    end
  end
end