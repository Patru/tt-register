# encoding: UTF-8

class Views::Tournaments::Tournament < Views::Layouts::SWPage
  @@table_fields=[:tour_id, :name, :date, :organiser]
  @@fields = @@table_fields.clone
  @@fields << :info_link
  @@fields << :logo
  @@fields << :stylesheet
  @@fields << :favicon
  @@fields << :sender_email
  @@fields << :bcc_email
  @@fields << :facebook_link
  @@fields << :layout_parser
  @@fields << :last_inscription_time
  @@fields << :only_show_playable_series
  @@fields << :thanks_for_interest_de
  @@fields << :thanks_for_interest_fr
  @@fields << :thanks_for_interest_en

  def fields
    @@fields
  end
  def table_fields
    @@table_fields
  end
  
  def tournament_form(button_text)
    labeled_table_form @tournament, fields, button_text
  end

  def show_menu
    menu_item tournament_path(@tournament), :show_tournament, eye_image
  end

  def edit_menu
    menu_item edit_tournament_path(@tournament), :edit_tournament, stylo_image
  end

  def list_menu
    menu_item tournaments_path, :list_tournaments, list_image
  end

  def new_menu
    menu_item new_tournament_path, :new_tournament, new_image
  end
end