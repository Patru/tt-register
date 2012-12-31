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
      click_button 'inscription_submit'
    end
    page.must_have_content "Die Einschreibung wurde erfolgreich erzeugt, bitte den Link in der Bestätigungs-Email verwenden."
    open_email my_email
    current_email.subject.must_equal "Bestätigung der Einschreibung"
    current_email.to.count.must_equal 1
    current_email.to[0].must_equal my_email
    current_email.must_have_link "http://"
    link=URI(current_email.find_link("http://").text)
    visit link.path
    page.must_have_content "Noch Nicht Angemeldet eingeloggt!"
    page.find('#rb_7')['disabled'].must_equal "disabled"
    page.find('#rb_1')['disabled'].must_be_nil
    choose('Herren Doppel C/D')
    click_button 'Anmelden'
    page.must_have_content "Deine Anmeldung wurde gespeichert."

#    save_and_open_page
  end

  it "must not be able to create an inscription without a valid email" do
    visit "/"
    within "form#new_inscription" do
      fill_in "inscription_licence", with: 700032
      click_button 'inscription_submit'
    end
    page.must_have_content "Fehler beim Anlegen der Einschreibung"
    page.must_have_content "Email hat ein ungültiges Format"
  end
end

=begin
Lieber Zwurgel Urgel  Herzlichen Dank für die Benutzung der Anmelde-Applikation.
        Bitte klicke auf den folgenden Link
http://www.example.com/inscriptions/3/f2yspMgn0Gy1P7Hc
um deine Email-Adresse zu bestätigen und deine sowie weitere Anmeldungen zu erfassen.
         Bitte behalte diese Email bis zum Turnier, denn damit kannst du rasch zusätzliche
An- oder Abmeldungen erfassen, der Link bleibt so lange aktiv. Herzliche Grüsse
das Zürich Open Team
=end
