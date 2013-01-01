#encoding: UTF-8
require "minitest_helper"

# To be handled correctly this spec must end with "Acceptance Test"
describe "CanSubmitOtherInscription Acceptance Test" do
  NICK_NAME = "this is a nickname"
  before do
    @player = players :ten
    new_inscription_with_name(NICK_NAME)
  end

  it "can add a Player with a licence" do
    within "form#licence" do
      fill_in "licence", with: @player.licence
      click_button "Hinzufügen"
    end
    page.must_have_content 'Bitte Serien auswählen um die Anmeldung abzuschliessen.'
    page.must_have_content 'Noch Nicht Angemeldet'
    choose('rb_1')
    click_button 'Anmelden'
    page.must_have_content 'Anmeldung von Noch Nicht Angemeldet wurde gespeichert.'
    click_link NICK_NAME
    within 'table#my_inscriptions' do
      page.must_have_link @player.long_name
      page.must_have_content 'Herren D'
    end
    within 'div#navigation' do
      page.link_with_text('Herren D').click
    end
    page.must_have_content @player.long_name
  end

  it "can add a Player by providing name" do
    within "form#sel_player" do
      fill_in "crit[name]", with: @player.name
      click_button "Auswählen"
    end
    page.must_have_content 'Bitte einen Spieler für die Anmeldung auswählen'
    click_link @player.long_name
    choose('rb_1')
    click_button 'Anmelden'
    page.must_have_content 'Anmeldung von Noch Nicht Angemeldet wurde gespeichert.'
    click_link NICK_NAME
    within 'table#my_inscriptions' do
      page.must_have_link @player.long_name
      page.must_have_content 'Herren D'
    end
    within 'div#navigation' do
      page.link_with_text('Herren D').click
    end
    page.must_have_content @player.long_name
  end

  it "can add a Player by providing club" do
    within "form#sel_player" do
      fill_in "crit[club]", with: @player.club
      click_button "Auswählen"
    end
    page.must_have_content 'Bitte einen Spieler für die Anmeldung auswählen'
    within 'table.players' do
      all(:link).count.must_equal 9
    end
    click_link @player.long_name
    choose('rb_1')
    click_button 'Anmelden'
    page.must_have_content 'Anmeldung von Noch Nicht Angemeldet wurde gespeichert.'
    click_link NICK_NAME
    within 'table#my_inscriptions' do
      page.must_have_link @player.long_name
      page.must_have_content 'Herren D'
    end
    within 'div#navigation' do
      page.link_with_text('Herren D').click
    end
    page.must_have_content @player.long_name
  end
end
