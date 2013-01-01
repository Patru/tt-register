#encoding: UTF-8
require "minitest_helper"

# To be handled correctly this spec must end with "Acceptance Test"
describe "CanAccessPrivacyInformation Acceptance Test" do
  it "does provide privacy information without login" do
    visit "/"
    click_link "Datenschutz"
    page.must_have_content "Datenschutzbestimmungen"
  end
end
