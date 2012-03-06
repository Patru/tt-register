require 'views/widget/tournament_series.rb'

class Views::Widget::SeriesBox < Views::Widget::TournamentSeries
  def format_row(tday, day_name, time, sers)
    checkbox_row(tday, day_name, time, sers)
  end

  def cb_options(serie)
    input = {:type => "checkbox",
             :name => "start[#{serie.tournament_day_id}][#{serie.id}]",
             :id => "cb_#{serie.id}", :value=> 1}
    td = {:class => 'series'}
    if serie.may_be_played_by? @player
      if @selected_map.key? serie then
        input[:checked] = "checked"
      end
    else
      input[:disabled]="disabled"
      td[:class] = 'forbidden_series'
    end
    [input, td]
  end

  def single_boxes(day_name, time, singles)
    tr do
      td do
        text day_name
      end
      td do
        text time
      end
      singles.each do |serie|
        input_opts, td_opts = cb_options serie
        td td_opts do
          input(input_opts)
          label :for => input_opts[:id] do
            text serie.long_name
          end
        end
      end
    end
  end

  def partner_field(doubl, disabled)
    name="start[#{doubl.tournament_day_id}][partner][#{doubl.id}]"
    ser_id="partner_#{doubl.id}"
    opts = {:type => "text", :name => name,
            :id => ser_id, :size => 30, :class => "partner",
            :title => "Name Vorname oder Lizemnzummer eingeben um den Partner auszuwählen."}
    if disabled
      opts.merge!({:disabled => "disabled"})
    else
      opts.merge!(
            :onFocus => "handle_default_focus(this)",
            :onBlur => "partner_blur(this)",
            "data-default" => "Name Vorname oder Lizenz für Auswahl")
    end
    if (not @partner_map.nil?) and (not @partner_map[doubl.id].nil?)
      opts[:value]=@partner_map[doubl.id].description
    end
    input(opts)

    unless disabled
      id_name="start[#{doubl.tournament_day_id}][partner_ids][#{doubl.id}]"
      hidden_opts={:type => 'hidden', :name=> id_name, :id => ser_id+"_id"}
      if not @partner_map.nil? and not @partner_map[doubl.id].nil?
        hidden_opts[:value]=@partner_map[doubl.id].id
      end
      input(hidden_opts)
    end
  end

  def double_box_partner(day_name, time, doubl)
    tr do
      td do
        text day_name
      end
      td do
        text time
      end
      input_opts, td_opts = cb_options doubl
      td td_opts do
        input(input_opts)
        label :for => input_opts[:id] do
          text doubl.long_name
        end
      end
      td :colspan => 2 do
        partner_field doubl, input_opts[:disabled]
      end
    end
  end

  def doubles_box_partners(day_name, time, doubles)
    first, *rest=doubles
    double_box_partner(day_name, time, first)
    rest.each do |doubl|
      double_box_partner("", "", doubl)
    end
  end

  def checkbox_row(tday, day_name, time, sers)
    doubles=[]
    singles=[]
    sers.each do |serie|
      if serie.double_series?
        doubles << serie
      else
        singles << serie
      end
    end
    doubles_box_partners(day_name, time, doubles) unless doubles.empty?
    single_boxes(day_name, time, singles) unless singles.empty?
  end
end