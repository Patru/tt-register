# encoding: UTF-8

class Views::Inscriptions::Show < Views::Inscriptions::Inscription
  def page_title
    'Einschreibung anzeigen'
  end

  def menu_items
    menu_item edit_inscription_path(@inscription), 'Diese Einschreibung ändern', stylo_image, "ändern"
  end
  
  def protect_against_forgery?
    true
  end
  
  def sw_content
    table do 
      labeled_data(:tournament_id, @inscription.tournament.name)
      fields.each do |field|
        show_data_item(@inscription, field)
      end
      show_data_item(@inscription, :email) if see_email?
    end
    if @inscription.attribute_present?(:licence) and own_inscription? then
      render_own_inscription
    else
      render_players("Anmeldungen", @inscription.inscription_players)
    end
    if @inscription.id == session[:id] or @admin then
      hr
      h2 "Neue Spieler anmelden"
      select_players_from_list
      add_player_with_licence
    end
  end
    
  def waiting_list
    return unless @inscription.own_inscription.waiting_list_entries.length > 0
    @inscription.own_inscription.waiting_list_entries.each do |waiting_day|
      p "Warteliste #{waiting_day.tournament_day.day_name}: #{waiting_day.series_list}; aktuell Nummer #{waiting_day.number_in_list} auf der Liste"
    end
  end

  def render_own_inscription
    hr
    h2 "Eigene Anmeldung"
    form_action = 'enroll'
    method_name = "Anmelden"
    if @inscription.own_inscription
      selected_series = @inscription.own_inscription.series
      form_action = "update_series"
      method_name = "Ändern"
    else
      selected_series = []
    end
    form_params = {:player => @inscription.own_player, :inscription => @inscription, :selected_series => selected_series}
    form_params[:inscription_player] = @inscription.own_inscription if @inscription.own_inscription
    form_tag(:controller => "inscription_players", :action => form_action) do
      widget(tournament.layouter_parser.layouter, form_params)
      input :type => "submit", :value => method_name
    end
    if @inscription.own_inscription then
      button_to("Leider kann ich nicht ans Turnier kommen, ich möchte mich Abmelden",  @inscription.own_inscription, :method => :delete,
          :confirm => "Möchtest du dich wirklich  vom Turnier abmelden?")
      waiting_list
    end
    render_players("Weitere Anmeldungen", @inscription.inscription_players_without_self)
  end

  private :render_own_inscription

  def add_player_with_licence
    p do
      text "Wenn du die Lizenznummer eines Spielers kennst, so kannst du sie hier "
      text "eingeben. Du brauchst dann nur noch die Serien auszuwählen."
    end
    form_tag({:controller => 'inscription_players', :action => 'add_player'}, {id: 'licence'}) do
      label "Lizenznummer"
      input :type => "text", :name => "licence", :size => 7
      input :type => "submit", :value => "Hinzufügen"
    end
  end
  
  def select_players_from_list
    p do
      text "In diesem Formular kannst du eine Liste mit Spielern anzeigen lassen aus denen du Spieler für die Einschreibung auswählen kannst. "
      text "Dabei kann der Club, der Name und/oder der Vorname eingeschränkt werden, wobei auch Teile von Namen verwendet werden können. "
      text "Für jeden eingeschriebenen Spieler müssen dann die Serien ausgewählt werden."
    end
    club_options = {:type => "text", :name => "crit[club]", :size => 20}
    club_options[:value]=@inscription.own_player.club if @inscription.own_player
    form_tag({:controller => 'inscriptions', :action => 'select_player'}, {id: 'sel_player'}) do
      input :type => "hidden", :name => 'id', :value => @inscription.id
      label "Club"
      input club_options
      label "Name"
      input :type => "text", :name => "crit[name]", :size => 20
      label "Vorname"
      input :type => "text", :name => "crit[first_name]", :size => 20
      input :type => "submit", :value => "Auswählen"
    end
  end
  
  def render_players title, inscription_players
    if inscription_players.size > 0
      hr
      h2 title
      table id: 'my_inscriptions' do
        thead do
          th "Name"
          th "Club"
          th "Eingeschrieben für"
          th :colspan=>2 do
            text "Aktionen"
          end
        end
        inscription_players.each do |ins_player|
          ins_player_row ins_player
        end
      end
    end
  end
  
  def ins_player_row ins_player
    tr do
      td do
        if (ins_player.inscription.id == session[:id]) then
          link_to ins_player.player.long_name, edit_inscription_player_path(ins_player)
        else
          link_to ins_player.player.long_name, ins_player
        end
      end
      td ins_player.player.club
      td ins_player.inscribed_for
      if @inscription.id == session[:id] or @admin then
        td do
          link_to(lightning_image, ins_player, :confirm => "Soll #{ins_player.player.long_name} wirklich abgemeldet werden?",
              :method => :delete, :title => 'abmelden')
        end
        td do
          link_to(right_arrow_image, url_for(:controller => :inscriptions, :id => ins_player.id, :only_path => true),
              :confirm =>  "Neue Einschreibung für #{ins_player.player.long_name} erzeugen?",
              :method => :post, :title => "Anmeldung an #{ins_player.player.long_name} übertragen")
        end
      end
    end
  end
end
