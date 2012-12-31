#encoding: UTF-8
require "minitest_helper"

# To be handled correctly this spec must end with "Acceptance Test"
describe "CanRequestAResendLink Acceptance Test" do
  NICK_NAME = "Mein Spitzname"
  before do
    new_inscription_with_name(NICK_NAME)
  end
  it "can request a new link" do
    save_and_open_page
    flunk "Need real tests"
  end
end
