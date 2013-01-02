#encoding: UTF-8
require "minitest_helper"
require "uri"

# To be handled correctly this spec must end with "Acceptance Test"
describe "CanCreateNewInscriptionWithLicence Acceptance Test" do
#  fixtures :players
  it "must be able to create an inscription with an existing user" do
    visit "/"
    clear_emails
    my_email = "nobody@nowhere.net"
    within "form#new_inscription" do
      fill_in "inscription_licence", with: 700032
      fill_in "inscription[email]", with: my_email
      click_button 'Einschreibung erstellen'
    end
    page.must_have_content "Die Einschreibung wurde erfolgreich erzeugt, bitte den Link in der Bestätigungs-Email verwenden."
    open_email my_email
    current_email.subject.must_equal "Bestätigung der Einschreibung"
    current_email.to.count.must_equal 1
    current_email.to[0].must_equal my_email
    current_email.must_have_content "http://"
    visit email_link_path(current_email)
    page.must_have_content "Noch Nicht Angemeldet eingeloggt!"
    page.find('#rb_7')['disabled'].must_equal "disabled"
    page.find('#rb_1')['disabled'].must_be_nil
    choose('Herren Doppel C/D')
    click_button 'Anmelden'
    page.must_have_content "Deine Anmeldung wurde gespeichert."
  end

  it "must not be able to create an inscription without a valid email" do
    visit "/"
    within "form#new_inscription" do
      fill_in "inscription_licence", with: 700032
      click_button 'Einschreibung erstellen'
    end
    page.must_have_content "Fehler beim Anlegen der Einschreibung"
    page.must_have_content "Email hat ein ungültiges Format"
  end
end

