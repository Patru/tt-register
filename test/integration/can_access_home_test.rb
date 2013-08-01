#encoding: UTF-8

require File.join(File.dirname(__FILE__), "..", "test_helper")

describe "can access home Integration Test" do
  it "can access the root path" do
    visit root_path
    within "div#header_logo" do
      page.must_have_link "home_link", {href: "/"}
    end
    within "div#header_text" do
      page.must_have_content "Zürich Open"
      page.must_have_link "Zürich Open", {href: "http://www.ttvz.ch"}
    end
    page.must_have_content "Lieber Tischtennisfreund"
    within "div#maincontent" do
      page.must_have_content "Eine neue Einschreibung erstellen"
      page.must_have_button "Einschreibung erstellen und E-Mail Adresse bestätigen"
      within "form#new_inscription" do
        page.find_field("Vorname Name")['name'].must_equal 'inscription[name]'
        page.find_field("Lizenznummer")['name'].must_equal 'inscription[licence]'
        page.find_field("Lizenznummer")['type'].must_equal 'number'
        page.find_field("me@my.host")['name'].must_equal 'inscription[email]'
        page.find_field("me@my.host")['type'].must_equal 'email'
      end
      within "div.copyright" do
        page.must_have_link "Soft-Werker GmbH", {href: "http://www.soft-werker.ch"}
      end
      within "div.commercial" do
        page.must_have_link "ERRA-Team", {href: "http://www.errateam.ch"}
        page.must_have_link "SpinnyShop", {href: "http://www.spinnyshop.com"}
      end
    end
  end

  it "delivers English text to a properly configured browser" do
    page.driver.header 'ACCEPT_LANGUAGE', 'en-GB'
    visit root_path
    page.must_have_content "Dear table tennis chap"
  end

  it "delivers French text to a properly configured browser" do
    page.driver.header 'ACCEPT_LANGUAGE', 'fr-FR'
    visit root_path
    page.must_have_content "Cher ami pongiste"
  end
end