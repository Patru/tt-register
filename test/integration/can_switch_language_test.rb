# encoding: UTF-8
require File.join(File.dirname(__FILE__), "..", "test_helper")

describe 'Language behavior Integration Test' do

  before do
    Capybara.current_driver = :webkit
  end

  after do
    Capybara.use_default_driver
  end

  it 'will retain a language specified in the session' do
    set_browser_language 'de-DE'   # used to be pointless in webkit-driver, no more ...
    visit root_path
    page.must_have_content "Lieber Tischtennisfreund"
    page.driver.header 'ACCEPT_LANGUAGE', 'fr-FR'
    visit root_path
    page.must_have_content "Cher ami pongiste"
    page.driver.header 'ACCEPT_LANGUAGE', 'en-GB'
    visit root_path
    page.must_have_content "Dear table tennis chap"
    page.must_have_selector "#language"
    page.select('Français', from: 'language')
    page.must_have_content "Cher ami pongiste"
    page.select('Deutsch', from: 'language')
    page.must_have_content "Lieber Tischtennisfreund"
    # for a random reason I do not understand this language sticks around until the next :webkit-Test
    # so we will make sure it is the default
  end
end