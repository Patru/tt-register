#encoding: UTF-8
require "test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "CanRequestAResendLink Integration Test" do
  before do
    new_inscription_with_name("Mein Spitzname")
  end
  it "can request a new link" do
    click_link "... und Tschüss, genug angemeldet für heute"
    click_link "Ich habe den Login-Link verloren"
    clear_emails
    within 'form#new_inscription' do
      fill_in 'inscription_email', with: @inscription.email
      click_button 'Neuen Login-Link schicken'
    end
    within 'div.notice' do
      page.must_have_content 'Der Link wurde neu generiert und dir zugestellt, die E-Mail sollte in wenigen Minuten ankommen.'
    end
    all_emails.count.must_equal 1
    open_email(@inscription.email)
    visit email_link_path(current_email)
    page.must_have_content "#{@inscription.name} ist jetzt eingeloggt"
  end
end
