#encoding: UTF-8
require "minitest_helper"

# To be handled correctly this spec must end with "Acceptance Test"
describe "CanCreateInscriptionWithName Acceptance Test" do
  DUMMY_NAME = "my name is nobody"
  it "won't be possible without an email" do
    visit "/"
    within "form#new_inscription" do
      fill_in "inscription_name", with: DUMMY_NAME
      click_button 'inscription_submit'
    end
    page.must_have_content "Fehler beim Anlegen der Einschreibung"
    page.must_have_content "Email hat ein ungültiges Format"
  end

  it "must create an inscription with name and email" do
    visit "/"
    clear_emails
    my_email = "nobody@nowhere.net"
    within "form#new_inscription" do
      fill_in "inscription_name", with: DUMMY_NAME
      fill_in "inscription[email]", with: my_email
      click_button 'inscription_submit'
    end
    page.must_have_content "Die Einschreibung wurde erfolgreich erzeugt, bitte den Link in der Bestätigungs-Email verwenden."
    open_email my_email
    current_email.subject.must_equal "Bestätigung der Einschreibung"
    link=URI(current_email.find_link("inscriptions").text)
    visit link.path
    page.must_have_content "#{DUMMY_NAME} eingeloggt!"
  end
end
