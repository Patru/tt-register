# encoding: UTF-8
require "test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "WillUseCorrectSalutation Integration Test" do
  before do
    Capybara.current_driver = :webkit
  end

  after do
    page.select('Deutsch', from: 'language')
    Capybara.use_default_driver
  end

  describe "use correct salutation in confirmation e-mail" do
    it "will use the female salutation using the default language" do
      email_address="dummy_sie@no-host.vu"
      visit root_path
      page.select('Deutsch', from: 'language')
      clear_emails
      within "form#new_inscription" do
        fill_in "inscription_licence", with: 700023
        fill_in "inscription[email]", with: email_address
        click_button 'Anmeldekonto erstellen'
      end
      page.must_have_content "Dein Anmeldekonto wurde erfolgreich erzeugt, bitte verwende ab jetzt den Link in der Bestätigungs-E-Mail."
      open_email email_address
      current_email.subject.must_equal "Erstellung des Anmeldekontos"
      current_email.must_have_text "Liebe Ricarda Strong"
    end

    it "uses the male salutation in german when appropriate" do
      email_address="dummy_er@no-host.vu"
      visit root_path
      page.select('Deutsch', from: 'language')
      clear_emails
      within "form#new_inscription" do
        fill_in "inscription_licence", with: 700011
        fill_in "inscription[email]", with: email_address
        click_button 'Konto erstellen'
      end
      page.must_have_content "Deine Anmeldekonto wurde erfolgreich erzeugt, bitte verwende ab jetzt den Link in der Bestätigungs-E-Mail."
      open_email email_address
      current_email.subject.must_equal "Erstellung des Anmeldekontos"
      current_email.must_have_text "Lieber Zworgel Orgel"
    end
  end

  describe "use French for the inscription" do
    it "uses the female salutation for confirmation" do
      email_address="frenchwoman@no-host.vu"
      visit root_path
      page.select('Français', from: 'language')

      clear_emails
      within "form#new_inscription" do
        fill_in "inscription_licence", with: 700021
        fill_in "inscription[email]", with: email_address
        click_button "créer le formulaire d'inscription et confirmer l'adresse e-mail"
      end
      page.must_have_content "Ton inscription a été créé avec succès, tu peux maintenant utiliser le lien d'inscription qui a été envoyé per e-mail."
      open_email email_address
      current_email.subject.must_equal "Confirmation de ton inscription"
      current_email.must_have_text "Chère Zwirgel Mirgel"
    end
  end
end
