class Views::Widget::TournamentSeries < Erector::Widget
#  needs :player, :inscription, :selected_series => [], :inscription_player => nil
  
  def options(group, serie)
    input = {:type => "radio", :name => group, :value => serie.id, :id => "rb_#{serie.id}"}
    td = {:class => 'series'}
    selected = false
    if serie.may_be_played_by? @player
      if @selected_map.key? serie then
        input[:checked] = "checked"
        selected = true
      end
    else
      input[:disabled]="disabled"
      td[:class] = 'forbidden_series'
    end
    [input, td, selected]
  end
  
  def radio_row(t_day, day_name, time, sers) 
    tr do
      series_selected=nil
      td do
        text day_name
      end
      td do
        text time
      end
      group_name = "start[#{t_day.id}][#{time}]"
      sers.each do |serie|
        input_opts, td_opts, selected = options group_name, serie
        series_selected = serie if selected
        td td_opts do
          input(input_opts) 
          label :for => input_opts[:id] do
            text serie.long_name
          end
        end
      end
      (sers.length..@max_series).each do
        td {}
      end
      button_id = "rb_keine#{time}"
      options = {:type => "radio", :name => group_name, :value => "keine", :id => button_id}
      options[:checked] ="checked" if series_selected.nil?
      td :class => 'series' do
        input(options) 
        label :for => button_id do
          text "keine Teilnahme"
        end
      end
    end
  end
  
  def self.default_url_options
    {}
  end
  
  def day_display(tday)
    tday.series_map.sort.each_with_index do |(time, sers), index|
      if index == 0 then
        day_name = tday.day_name
      else
        day_name = ""
      end
      radio_row(tday, day_name, time, sers)
    end
  end

  def headers
    tr do
      th "Tag"
      th "Zeit"
      th "Serien"
    end
  end

  def render
    determine_max_series
    selected_series_map
    h2 "#{@player.long_name}, #{@player.player_info}"
    if not @inscription.licence or @inscription.licence != @player.licence then
      p do
        text "angemeldet durch "
        link_to @inscription.name, @inscription
      end
    end
    input :type => "hidden", :name => "id", :value => @inscription_player.id if @inscription_player
    input :type => "hidden", :name => "player_id", :value => @player.id
    input :type => "hidden", :name => "tournament_id", :value => @inscription.tournament.id
    input :type => "hidden", :name => "inscription_id", :value => @inscription.id
    table do
      headers
      @inscription.tournament.tournament_days.each do |tday|
        day_display tday
      end
    end
  end

  def determine_max_series
    @max_series = @inscription.tournament.tournament_days.collect{|tday| tday.max_series}.max
  end
  
  def selected_series_map
    @selected_map = {}
    @selected_series.each do |ser|
      @selected_map[ser] = "selected"
    end
  end
end