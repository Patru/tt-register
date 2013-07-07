# encoding: UTF-8
require "test_helper"
require "minitest-spec-context"

# To be handled correctly this spec must end with "Integration Test"
describe "Display relevant back link Integration Test" do
  describe "for a user without inscription" do
    it "will show a new_inscription link while browsing series" do
      visit root_path
      within "div#navigation" do
        click_link "Damen A"
      end
      within "div#heading" do
        page.must_have_content "Anmeldungen für Damen A"
      end
      within "div#menu" do
        page.must_have_link "Neue Einschreibung"
        page.wont_have_link "Meine Einschreibung"
      end
    end
  end

  describe "for users with an active inscription" do
    NICK_NAME = "this is another nickname"
    before do
      new_inscription_with_name(NICK_NAME)
    end
    it "will show a link to the inscription" do
      within "div#navigation" do
        click_link "Damen A"
      end
      within "div#menu" do
        page.wont_have_link "Neue Einschreibung"
        page.must_have_link "Meine Einschreibung"
      end
    end
  end
end
