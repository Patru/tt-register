# encoding: UTF-8

class Views::Inscriptions::Show < Views::Inscriptions::Inscription
  def page_title
    t(:show_inscription)
  end

  def menu_items
    edit_menu if logged_in?
  end

  def back_link
    new_inscription_menu
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
      render_players(t(:inscriptions), @inscription.inscription_players)
    end
    if @inscription.id == session[:id] or is_admin? then
      hr
      h2 t('add_players.title')
      p t('add_players.explanation')
      select_players_from_list
      p t('add_player_with_licence')
      add_player_with_licence
    end
  end
    
  def waiting_list
    return unless @inscription.own_inscription.waiting_list_entries.length > 0
    @inscription.own_inscription.waiting_list_entries.each do |waiting_day|
      p t('waiting_list.full', day:waiting_day.tournament_day.day_name, series: waiting_day.series_list,
          number: waiting_day.number_in_list)
    end
  end

  def render_own_inscription
    hr
    h2 t 'title.own_inscription'
    form_action = 'enroll'
    if @inscription.own_inscription
      selected_series = @inscription.own_inscription.series
      form_action = "update_series"
      method_name = t 'button.update'
    else
      selected_series = []
      method_name = t 'button.enroll'
    end
    form_params = {:player => @inscription.own_player, :inscription => @inscription, :selected_series => selected_series}
    form_params[:inscription_player] = @inscription.own_inscription if @inscription.own_inscription
    form_tag({controller: "inscription_players", action: form_action}, class: 'sers') do
      widget(tournament.layouter_parser.layouter, form_params)
      input :type => "submit", :value => method_name
    end
    if @inscription.own_inscription then
      if not @inscription.own_inscription.all_series_past_end_of_inscriptions?
        button_to(t('button.sign_off_own'),  @inscription.own_inscription, :method => :delete,
            :confirm => t('confirm.sign_off_own'))
      else
        button_to(t(:sign_off_inscription_expired), email_form_path, :method => :get)
      end
      waiting_list
    end
    render_players(t('title.further_inscriptions'), @inscription.inscription_players_without_self)
  end

  private :render_own_inscription

  def add_player_with_licence
    form_tag({:controller => 'inscription_players', :action => 'add_player'}, {id: 'licence'}) do
      label t(:licence_number)
      input type: 'number', name: 'licence', size: 7, placeholder: t(:licence)
      input :type => "submit", :value => t('button.add')
    end
  end
  
  def select_players_from_list
    club_options = {:type => "text", :name => "crit[club]", :size => 20}
    club_options[:value]=@inscription.own_player.club if @inscription.own_player
    form_tag({:controller => 'inscriptions', :action => 'select_player'}, {id: 'sel_player'}) do
      input :type => "hidden", :name => 'id', :value => @inscription.id
      label attribute_label(:club)
      input club_options
      label attribute_label(:name)
      input :type => "text", :name => "crit[name]", :size => 20
      label attribute_label(:first_name)
      input :type => "text", :name => "crit[first_name]", :size => 20
      input :type => "submit", :value => t(:select)
    end
  end
  
  def render_players title, inscription_players
    if inscription_players.size > 0
      hr
      h2 title
      table id: 'my_inscriptions' do
        thead do
          th t('attributes.name')
          th t('attributes.club')
          th t('attributes.inscribed_for')
          th :colspan=>2 do
            text t(:actions)
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
          if (not ins_player.all_series_past_end_of_inscriptions?) or @admin
            link_to(lightning_image, ins_player, :confirm => t(:really_sign_off, player: ins_player.player.long_name),
                    :method => :delete, :title => t(:sign_off))
          else
            link_to(lightning_image, email_form_path, :title => t(:sign_off_inscription_expired))
          end
        end
        td do
          link_to(right_arrow_image, own_inscription_path(:id => ins_player.id),
              :confirm =>  t('confirm.create_new_inscription', long_name:ins_player.player.long_name),
              method: :post, title: t('confirm.transfer_inscription', long_name:ins_player.player.long_name))
        end
      end
    end
  end
end
