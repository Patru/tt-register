#encoding: UTF-8
require "test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "CanRequestAResendLink Integration Test" do
  NICK_NAME = "Mein Spitzname"
  before do
    new_inscription_with_name(NICK_NAME)
  end
  it "can request a new link" do
    click_link "... und Tschüss, genug angemeldet für heute"
    click_link "Natürlich stellen wir dir auch einen neuen login-Link zu"
    clear_emails
    within 'form#new_inscription' do
      fill_in 'inscription_email', with: @inscription.email
      click_button 'Link zustellen'
    end
    within 'div.notice' do
      page.must_have_content 'Link neu zugestellt, die Email sollte in wenigen Minuten ankommen.'
    end
    all_emails.count.must_equal 1
    open_email(@inscription.email)
    visit email_link_path(current_email)
    page.must_have_content "#{@inscription.name} eingeloggt"
  end
end
