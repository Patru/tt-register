#encoding: UTF-8
require "test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "CanAccessPrivacyInformation Integration Test" do
  it "does provide privacy information without login" do
    visit root_path
    click_link "Datenschutz"
    page.must_have_content "Datenschutzbestimmungen"
  end
end
