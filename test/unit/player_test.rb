require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  it "responds to #canton and #rv and can assign them" do
    pl=Player.new()
    pl.must_respond_to :canton
    pl.must_respond_to :rv
    pl.canton="ZH"
    pl.rv="OTTV"
  end


  it "should match all U-categories for U9 players" do
    dario = players(:dario)
    dario.matches_category?("U21").must_equal true
    dario.matches_category?("U11").must_equal true
    dario.matches_category?("U9").must_equal true
    dario.matches_category?("U8").must_equal false
    dario.matches_category?("O40").must_equal false
  end
end
