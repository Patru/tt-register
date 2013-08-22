# encoding: UTF-8

require 'views/labels.rb'
require 'views/columns.rb'

class String
  def mail_escape
    gsub(/ /, "%20").gsub(/\\n/, "%0D%0A")
    #let's see wether this is all?
  end
end

class Views::Layouts::SWPage < Erector::Widgets::Page
#class Views::Layouts::SWPage < Views::Layouts::Page
  depends_on :js, "/assets/application.js"

  def self.default_url_options
    {}
  end
  def html_attributes
    {:xmlns => 'http://www.w3.org/1999/xhtml', 'xml:lang' => 'en', :lang => 'de'}
  end
  def app_start_year
    2009
  end
  def flash_type(type, css_class)
    if flash[type] != nil 
      div :class=>css_class do
        text flash[type]
      end
    end
  end

  def head_content
    super
    link :rel => "shortcut icon", :type => "image/x-icon", :href => favicon
    csrf_meta_tags
    # these should not be necessary, depends_on somehow broken?
    link :rel => "stylesheet", :href => stylesheet, :type => "text/css", :media => "all"
    script({:type => "text/javascript", :src => '/assets/application.js'})
  end
  
  def tournament
    if @series.respond_to?(:tournament_day) then
      series = @series
    elsif @series.kind_of?(Array) and @series.length > 0 and respond_to?(:tournament_day) then
      series = @series[0]
    else
      series = nil
    end
    if @inscription and @inscription.tournament then
      return @inscription.tournament
    elsif @inscription_player and @inscription_player.inscription and @inscription_player.inscription.tournament
      return @inscription_player.inscription.tournament
    elsif series and series.tournament_day and series.tournament_day.tournament then
      return series.tournament_day.tournament
    elsif @tournament and not @tournament.new_record? then
      return @tournament
    else
      return ::Tournament.next
    end
  end
  
  def stylesheet
    if tournament and tournament.stylesheet then
      return tournament.stylesheet
    else
      return "/stylesheets/neutral.css"
    end
  end
    
  def favicon
    if tournament and tournament.favicon then
      return tournament.favicon
    else
      return "/favicon.ico"
    end
  end

  def show_flash
    flash_type :notice, "notice"
    flash_type :message, "message"
    flash_type :error, "errorExplanation"
  end
  def body_content
    if tournament then
      tournament_header tournament
    end
    div :id => "menu" do
      page_menu
    end
    div :id => "navigation" do
      navigation
    end
    show_flash
    div :id => "maincontent" do
      sw_content
      sw_footer
    end
  end

  def span_title(tour_day)
    title = tour_day.day_name + ": "
    title << tour_day.count_entries.to_s
    title << " von maximal "
    title << tour_day.max_inscriptions.to_s
    title << " Serienplätzen sind belegt, "
    if tour_day.entries_remaining? then
      title << "Anmeldungen sind weiterhin möglich."
    else
      title << "weitere Anmeldungen werden auf die Warteliste gesetzt."
    end
    return title
  end
  
  def tournament_header tournament
    div :id => 'tournament_header' do
      if tournament.logo then
        div :id => 'header_logo' do
          link_to root_path, id: 'home_link' do
            img :src => tournament.logo, :align => 'top', :height => 101, :alt => "logo"
          end
        end
      end
      div :id => "header_text" do
        h1 do
          link_to tournament.name, tournament.info_link, {target: :blank, title: t('title.info_on_tournament')}
        end
        p do
          text t(:inscriptions) + ": "
          tournament.tournament_days.each do |tour_day|
            if tour_day.entries_remaining? then
              day_class = "open"
            else
              day_class = "closed"
            end
            span :class => day_class, :title => span_title(tour_day) do
              text tour_day.day_name
              text ": "
              text tour_day.count_entries
              text "/"
              text tour_day.max_inscriptions
              text " "
            end
          end
        end
        div :id => "heading" do
          h1 do
            text page_heading
          end
        end
      end
    end
  end
  def sw_content
    instance_eval(&@block) if @block
  end

  def commercial
    div :class => "commercial" do
      link_to erra_team_image, "http://www.errateam.ch", target: "_blank"
      link_to spinny_shop_image, 'http://www.spinnyshop.com', target: "_blank"
    end
  end

  def copyright
    this_year = Time.now.year
    copy_year = app_start_year.to_s
    if this_year > app_start_year then
      copy_year = copy_year+"—"+this_year.to_s
    end
    div :class => "copyright" do
      p :class => 'footer' do
        text '© '
        link_to 'Soft-Werker GmbH', 'http://www.soft-werker.ch'
        text ' '
        text copy_year
      end
    end
  end

  def sw_footer
    div :id => "footer" do
      commercial
      copyright
    end
  end

  def page_menu
    menu_list
    standard_menu
  end
  def page_heading
    page_title
  end
  def navigation
    ul do
      language_selection
      admin_menu
      series_menu
    end
  end

  def language_selection
    li do
      widget(Form.new(action: set_language_path, method: "post") do
        input name: "authenticity_token", type: "hidden", value: form_authenticity_token
        select_tag('language', options_for_select(
                      [['Deutsch', 'de'], ['English', 'en'], ['Français', 'fr']], I18n.locale),
                   {onchange: "this.form.submit()".html_safe})
        end)
    end
  end

  def admin_menu
    return unless @admin
    li do
      text "Administration"
      ul do
        li do
          link_to("Einschreibungen", inscriptions_path)
        end
        li do
          link_to('Serien', url_for(:controller=>"series", :action=>"index", :only_path=>true))
        end
        li do
          link_to("Spieler", players_path)
        end
         li do
          link_to("Turniere", tournaments_path)
        end
        li do
          link_to("Turniertage", tournament_days_path)
        end
        li do
          link_to "Logout", logoff_admin_path
        end
      end
    end
  end
  def series_menu
    seris = tournament.tournament_days.collect{|tour_day| tour_day.series}.flatten.sort
    li do
      text t(:series_plural)
      ul do
        seris.each do |seri|
          li do
#            url_for(:controller => "series", :id => seri.id, :action => "players")
            link_to seri.translated_name, series_players_path(id: seri.id)
                    # :controller => "series", :id => seri.id, :action => "players"
          end
        end
      end
    end
  end
  
  def email(address, subject='', body='')
    seed = rand(99)
    var = "eax"+rand(999).to_s
    adr = []
    for i in 0...address.length do
      adr << address[i]+seed
    end
    javascript do
      rawtext "var seed=#{seed};"
      rawtext "eCharsArray=[#{adr.join(',')}];"
      rawtext "#{var}='';"
      rawtext "for(var i=0; i<eCharsArray.length; i++) {"
      rawtext "  #{var}+=String.fromCharCode(eCharsArray[i]-seed);"
      rawtext "}"
      rawtext "document.write('<a href=\""
      rawtext "mailto:'+#{var}+'?subject=#{subject.mail_escape}"
      rawtext "&body=#{body.mail_escape}\">'+#{var}+'</a>');"
    end
  end
  def labeled_data label_symbol, data
    tr do
      td :class => 'label' do
        text attribute_label(label_symbol) #Views::Labels.label(label_symbol)
        text ":"
      end
      td do 
        text data
      end
    end
  end
  def show_data_item data, symbol
    labeled_data symbol, data.send(symbol)
  end
  def show_data_table data, *fields
    if fields.length == 1 and fields[0].is_a?(Array)
      fields = fields[0]
    end
    table do 
      fields.each do |field|
        show_data_item(data, field)
      end
    end
  end
  def data_fields worker, *fields
    if fields.length == 1 and fields[0].is_a?(Array)
      fields = fields[0]
    end
    fields.each do |sym|
      td do 
        text worker.send(sym)
      end
    end
  end
  def headers *fields
    if fields.length == 1 and fields[0].is_a?(Array)
      fields = fields[0]
    end
    tr do 
      fields.each do |field|
        th :align => 'left' do 
          text column_header(field)
        end
      end
    end
  end

  def column_header(symbol)
    attribute_label symbol
  end

  def attribute_label(symbol)
    I18n.t("attributes.#{symbol}")
  end

  def translated_text(clazz, symbol)
    trans_text=clazz.human_attribute_name(symbol)+":"
    if trans_text =~ /missing/
      trans_text = Views::Labels.label(symbol)
    end
    trans_text
  end

  def label_text(form, symbol)
    translated_text form.object.class, symbol
  end
  def form_text_field form, symbol, options={}
    tr do
      td :class => 'label' do
        rawtext form.label(symbol, label_text(form, symbol))
      end
      td do
        rawtext form.text_field(symbol, options)
      end
    end
  end

  def form_text_area form, symbol, options={}
    area_opts = {cols:60, rows:20}.merge(options)
    tr do
      td :class => 'label', :valign => "top" do
         rawtext form.label(symbol, Views::Labels.label(symbol))
      end
      td do
        rawtext form.text_area(symbol, area_opts)
      end
    end
  end

  def form_password_field form, symbol, options={}
    tr do
      td :class => 'label' do
         rawtext form.label(symbol, Views::Labels.label(symbol))
      end
      td do
        rawtext form.password_field(symbol, options)
      end
    end
  end

  def form_hidden_field builder, symbol, display_text = nil
    tr do
      td :class => 'label' do
        rawtext builder.label(Views::Labels.label(symbol))
      end
      td do
        if display_text then
          text display_text
        else
          text builder.object.send(symbol)
        end
        input :type=>'hidden', :name => "#{builder.parent.object_name}[#{symbol}]", :value => builder.object.send(symbol)
      end
    end
  end
  
  def form_time_select form, symbol
    tr do
      td :align => 'right' do
         rawtext form.label(symbol, Views::Labels.label(symbol))
      end
      td do
        rawtext form.time_select(symbol, { :minute_step => 5})
      end
    end
  end
  
  def form_datetime_select form, symbol
    tr do
      td :align => 'right' do
         rawtext form.label(symbol, Views::Labels.label(symbol))
      end
      td do
        rawtext form.datetime_select(symbol)
      end
    end
  end
  
  def form_date_select form, symbol
    tr do
      td :align => 'right' do
         rawtext form.label(symbol, Views::Labels.label(symbol))
      end
      td do
        rawtext form.date_select(symbol)
      end
    end
  end
  
  def labeled_table_form(object, symbols, button_text)
    form_for(object) do |f|
      rawtext f.error_messages
      table do
        symbols.each do |symb|
          form_text_field f, symb
        end
      end
      p do
        rawtext f.submit(button_text)
      end
    end
  end
  
  def stylo_image
    @@stylo_image ||= capture{image_tag("stylo.png", :border=>0)}
  end

  def lightning_image
    @@lightning_image ||= capture{image_tag("lightning.png", :border=>0)}
  end

  def eye_image
    @@eye_image ||= capture{image_tag("show.png", :border=>0)}
  end

  def message_image
    @@message_image ||= capture{image_tag("message.png", :border=>0)}
  end

  def right_arrow_image
    @@right_arrow_image ||= capture{image_tag("right_arrow.png", :border=>0)}
  end

  def list_image
    @@list_image ||= capture{image_tag("list.png", :border=>0, :style => "vertical-align:middle")}
  end

  def new_image
    @@new_image ||= capture{image_tag("arrow.png", :border=>0)}
  end

  def lock_image
    @@lock_image ||= capture{image_tag("lock.png", :border=>0)}
  end

  def exit_image
    @@exit_image ||= capture{image_tag("ausgang.png", :border=>0)}
  end

  def commercialImage(image, alt)
    capture { image_tag(image, :border => 0, :style => "vertical-align:middle",
                        alt: alt, title: alt) }
  end

  def erra_team_image
    @@erra_team_image ||= commercialImage("erra-team.png", "ERRA-Team")
  end

  def spinny_shop_image
    @@spinny_shop_image ||= commercialImage("SpinnyShop.png", "SpinnyShop")
  end

  def menu_list
    ul :class => "context" do
      back_link
      menu_items
    end
  end

  def back_link
    if @inscription
      my_inscription_link
    elsif not is_admin?
      menu_item root_path, :new_inscription, new_image
    end
  end

  def my_inscription_link
    menu_item inscription_path(@inscription), :my_inscription, list_image
  end

  def valid_inscription
    @inscription and not @inscription.id.nil?
  end

  def standard_menu
    ul :class => "standard" do
      menu_item protection_path, :privacy, lock_image
      menu_item email_form_path, :email, message_image
      menu_item logout_path, :exit, exit_image if valid_inscription and not is_admin?
    end
  end

  def menu_items

  end

  def menu_item(url, tag, image)
    menu_item_base(url, t("links.#{tag}.title"), image, t("links.#{tag}.text"))
  end

  def menu_item_base(url, title, image, txt)
    li do
      a(:href => url, :title => title) do
        rawtext image if image
        text " "
        text txt
      end
    end
  end
end