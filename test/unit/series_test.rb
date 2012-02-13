require 'test_helper'

class SeriesTest < ActiveSupport::TestCase
  test "ranking of players in men series" do
    men_single=series(:menD)
    assert 1, men_single.ranking_of(players(:one))
    assert 1, men_single.ranking_of(players(:two))
  end

  test "ranking of players in women series" do
    women_double=series(:womenDouble)
    assert_nil women_double.ranking_of(players(:one))
    assert 3, women_double.ranking_of(players(:two))
  end

  test "ranking of players in mixed series" do
    mixed=series(:mixedDouble)
    assert_equal 1, mixed.ranking_of(players(:one))
    assert_equal 3, mixed.ranking_of(players(:two))
  end

  test "rank of players in men series" do
    men_d=series(:menD)
    assert_nil men_d.rank_of(players(:one))
    assert_nil men_d.rank_of(players(:five))
    men_a=series(:menA)
    assert_nil men_a.rank_of(players(:one))
    assert_equal 50, men_a.rank_of(players(:five))
    assert_nil men_a.rank_of(players(:six))
    assert_equal 51, men_a.rank_of(players(:seven))
  end

  test "rank of playrs in women series" do
    women_a=series(:womenA)
    assert_nil women_a.rank_of(players(:five))
    assert_equal 20, women_a.rank_of(players(:six))
    assert_equal 2, women_a.rank_of(players(:seven))
  end

  test "rank of players in women double series" do
    women_double_a=series(:womenDoubleA)
    assert women_double_a.female?
    assert_equal 17, women_double_a.ranking_of(players(:six))
    assert_equal 20, women_double_a.ranking_of(players(:seven))
  end
end
