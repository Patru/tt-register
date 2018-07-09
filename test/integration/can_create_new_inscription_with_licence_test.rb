#encoding: UTF-8
require "test_helper"
require "uri"

# To be handled correctly this spec must end with "Integration Test"
describe "CanCreateNewInscriptionWithLicence Integration Test" do
#  fixtures :players
  it "must be able to create an inscription with an existing user" do
    visit root_path
    clear_emails
    my_email = "nobody@nowhere.net"
    within "form#new_inscription" do
      fill_in "inscription_licence", with: 700032
      fill_in "inscription[email]", with: my_email
      click_button 'Anmeldekonto erstellen'
    end
    page.must_have_content "Dein Anmeldekonto wurde erfolgreich erzeugt, bitte verwende ab jetzt den Link in der Bestätigungs-E-Mail."
    open_email my_email
    current_email.subject.must_equal "Erstellung des Anmeldekontos"
    current_email.to.count.must_equal 1
    current_email.to[0].must_equal my_email
    current_email.must_have_content "http://"
    visit email_link_path(current_email)
    page.must_have_content "Noch Nicht Angemeldet ist jetzt eingeloggt!"
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
      click_button 'Konto erstellen'
    end
    page.must_have_content "Fehler beim Anlegen des Anmeldekontos"
    page.must_have_content "E-Mail hat ein ungültiges Format"
  end
end

