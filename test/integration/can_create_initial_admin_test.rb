#encoding: UTF-8
require "test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "Can Upload Licence File Integration Test" do
  it "can create an inital admin through the GUI" do
    visit admins_path
    within 'div#heading h1' do
      page.must_have_text "Liste der Administratoren"
    end
    click_link "New Admin"
    clear_emails
    within 'form#new_admin' do
      fill_in 'admin[name]', with: 'dummy admin'
      fill_in 'admin[email]', with: 'nowhere@near.or.far'
      fill_in 'admin[password]', with: 'none'
      click_button 'Erzeugen'
    end
    Admin.first.wont_be_nil
    all_emails.count.must_equal 1
    open_email 'nowhere@near.or.far'
    visit email_link_path(current_email)
    within 'form#edit_admin_1' do
      fill_in 'admin[password]', with: 'none'
      click_button 'Anmelden'
    end

    within 'div#navigation' do
      page.must_have_text 'Administration'
    end
    within 'div.notice' do
      page.must_have_text 'eingeloggt'
    end
  end

  it "provides useful information if something is amiss" do
    visit new_admin_path
    within 'form#new_admin' do
      fill_in 'admin[name]', with: 'dummy admin'
      fill_in 'admin[email]', with: 'nowhere@near.or.far'
      click_button 'Erzeugen'
    end
    within 'div.errorExplanation' do
      page.must_have_text 'Passwort muss ausgefüllt werden'
    end
  end
end
