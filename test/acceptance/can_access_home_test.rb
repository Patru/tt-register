#encoding: UTF-8

require File.join(File.dirname(__FILE__), "..", "minitest_helper")

describe "can access home Acceptance Test" do
  it "can access the root path" do
    visit "/"
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
end