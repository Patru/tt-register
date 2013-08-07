#encoding: UTF-8
require File.join(File.dirname(__FILE__), '..', 'test_helper')

# To be handled correctly this spec must end with "Integration Test"
describe "CanAccessPrivacyInformation Integration Test" do
  it "does provide privacy information without login" do
    visit root_path
    within "ul#help_links" do
      click_link "Datenschutz"
    end
    page.must_have_content "Datenschutzbestimmungen"
  end
end
