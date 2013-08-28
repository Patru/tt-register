# encoding: UTF-8

class Views::Series::Series < Views::Layouts::SWPage
  def series_form(button_text)
    form_for @series, :as => :series,
             :url => @series.new_record? ? {:action => 'create'}:{:action => 'update', :id=>@series },
             :html => @series.new_record? ? {}:{:method => :put} do |f|
      rawtext f.error_messages
      table do
        tr do
          td :align => 'right' do
            rawtext f.label(Views::Labels.label(:tournament_day_id))
          end
          td do
            rawtext f.collection_select(:tournament_day_id,
                                        TournamentDay.find(:all, :order => "day"), :id, :display_name)
          end
        end
        form_text_field f, :series_name
        form_text_field f, :long_name
        form_time_select f, :start_time
        form_text_field f, :min_ranking
        form_text_field f, :max_ranking
        form_text_field f, :category
        form_text_field f, :sex
        form_text_field f, :use_rank
        form_text_field f, :type
      end
      p do
        rawtext f.submit(button_text)
      end
    end
  end
  
  @@text_fields = [:series_name, :long_name, :start_time, :min_ranking, :max_ranking, :category, :sex]
  @@fields = [:tournament_day_id].concat @@text_fields
  
  def fields
    @@fields
  end
  
  def text_fields
    @@text_fields
  end

  def show_menu
    menu_item series_path(@series), :show_series, eye_image
  end

  def edit_menu
    menu_item edit_series_path(@series), :edit_series, stylo_image
  end

  def list_menu
    menu_item url_for(:controller=>"series", :action=>"index", :only_path=>true), # no plural, must do it explicitly
              :list_series, list_image
  end

  def new_menu
    menu_item new_series_path, :new_series, new_image
  end
end