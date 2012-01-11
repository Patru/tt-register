require 'views/series/list'

class Views::TournamentDays::Show < Views::TournamentDays::TournamentDay
#  needs :tournament_day, :tournament_days, :series => nil, :inscription => nil
  def page_title
    'Turniertag anzeigen'
  end

  def menu_items
    menu_item edit_tournament_day_path(@tournament_day), "Diesen Tag ändern", stylo_image, "ändern"
  end

  def sw_content
    table do 
      labeled_data(:tournament_id, @tournament_day.tournament.name)
      [:day, :max_inscriptions, :series_per_day].each do |field|
        show_data_item(@tournament_day, field)
      end
    end
    if @series != nil and @series.length > 0 then
      h2 "Serien für diesen Tag"
      widget Views::Series::List, :series => @series
      hr
      form_tag copy_day_path, :method => "post" do
        label "Kopiere Serienstruktur nach "
#        input :type => "hidden", :name => 'authenticity_token', :value => form_authenticity_token
        input :type => "hidden", :name => 'source_id', :value => @tournament_day.id
        select :name => "target_id" do
          # options_for_select
          @tournament_days.each do |td|
            option td.display_name, :value => td.id
          end
        end
        input :type => "submit", :value => "Durchführen"
      end
    end
  end
end
