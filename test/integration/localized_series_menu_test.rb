#encoding: UTF-8
require "test_helper"

describe "LocalizedSeriesMenu Integration Test" do

  before do
    Capybara.current_driver = :webkit
  end

  after do
    page.select('Deutsch', from: 'language')
    Capybara.use_default_driver
  end

  it "must render the german series_menu by default" do
    set_browser_language 'de-DE'
    visit root_path
    within "div#navigation" do
      page.must_have_select "language", selected: 'Deutsch'
      page.must_have_content "Damen A"
      page.must_have_content "Damen Doppel A/B"
      page.must_have_content "Herren Doppel C/D"
      page.must_have_content "Mixed Doppel A/B"
      page.must_have_content "Elite"
      page.must_have_content "Herren D"
    end
  end

  it "must render the french series_menu when that language is selected" do
    visit root_path
    within "div#navigation" do
      page.select('Français', from: 'language')
      page.must_have_content "Dames A"
      page.must_have_content "Double dames A/B"
      page.must_have_content "Double messieurs C/D"
      page.must_have_content "Double mixte A/B"
      page.must_have_content "Élite"
      page.must_have_content "Messieurs D"
    end
  end
end
