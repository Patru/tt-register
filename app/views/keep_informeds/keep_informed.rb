# encoding: UTF-8

class Views::KeepInformeds::KeepInformed < Views::Layouts::SWPage
  def keep_informed_form(button_text)
    labeled_table_form @keep_informed, [:email, :unlicensed, :salutation], button_text
  end

  def show_menu
    #menu_item keep_informed_path(@keep_informed), :show_keep_informed, eye_image unless is_admin?
    menu_item_emoji keep_informed_path(@keep_informed), :show_keep_informed
  end

  def list_menu
    menu_item players_path, :list_keep_informeds, list_image
  end

  def new_menu
    menu_item new_keep_informed_path, :new_keep_informed, new_image
  end

  def edit_menu
    menu_item edit_keep_informed_path(@keep_informed), :edit_keep_informed, stylo_image
  end
end