require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  it "responds to #canton and #rv and can assign them" do
    pl=Player.new()
    pl.must_respond_to :canton
    pl.must_respond_to :rv
    pl.canton="ZH"
    pl.rv="OTTV"
  end
end
