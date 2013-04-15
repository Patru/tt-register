#encoding: UTF-8
require "test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "CanSubmitOwnInscription Integration Test" do
  before do
    @player = Player.where(licence:700032).first
    new_inscription_with_licence(@player.licence)
  end
  it "can participate in mens double cd" do
    page.must_have_content "Eigene Anmeldung"
    series = "Herren Doppel C/D"
    choose(series)
    click_button("Anmelden")
    within "div.notice" do
      page.must_have_content "Deine Anmeldung wurde gespeichert."
    end
    page.must_have_checked_field series
    within "div#navigation" do
      click_link series
    end
    page.must_have_content(@player.long_name)
  end

  it "can participate in men single d" do
    page.must_have_content "Eigene Anmeldung"
    choose("rb_1")    #select this button by id, Herren D is no unique match (see above)
    click_button("Anmelden")
    within "div.notice" do
      page.must_have_content "Deine Anmeldung wurde gespeichert."
    end
    page.must_have_checked_field "rb_1"
    within "div#navigation" do
      page.link_with_text("Herren D").click
    end
    page.must_have_content @player.long_name
  end
end
