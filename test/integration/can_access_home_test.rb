#encoding: UTF-8

require File.join(File.dirname(__FILE__), "..", "test_helper")

describe "can access home Integration Test" do
  it "can access the root path" do
    visit root_path
    page.must_have_content "Lieber Tischtennisfreund"
    within "div#maincontent" do
      page.must_have_content "Neue Einschreibung erstellen"
      page.must_have_button "Einschreibung erstellen"
      within "form#new_inscription" do
        page.find_field("Vorname Name")['name'].must_equal 'inscription[name]'
        page.find_field("Lizenznummer")['name'].must_equal 'inscription[licence]'
        page.find_field("Lizenznummer")['type'].must_equal 'number'
        page.find_field("me@my.host")['name'].must_equal 'inscription[email]'
        page.find_field("me@my.host")['type'].must_equal 'email'
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