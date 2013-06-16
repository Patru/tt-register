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
#    page.driver.header 'ACCEPT_LANGUAGE', 'de-DE'# pointless in webkit-driver, strange
 #   page.driver.header 'refrer', 'bla bla de-DE'
  #  page.driver.header 'nana', 'bla bla -DE'
    visit root_path
    page.must_have_content "Lieber Tischtennisfreund"
#    page.driver.header 'ACCEPT_LANGUAGE', 'fr-FR'
#    visit root_path
#    page.must_have_content "Cher ami pongiste"
    page.driver.header 'ACCEPT_LANGUAGE', 'en-GB'
    visit root_path
    page.wont_have_content "Dear table tennis chap"
    page.must_have_selector "#language"
    save_and_open_page
    page.select('Français', from: 'language')
    save_and_open_page
    page.must_have_content "Cher ami pongiste"
  end
end