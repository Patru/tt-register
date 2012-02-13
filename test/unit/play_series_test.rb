require "test/unit"

class PlaySeriesTest < ActiveSupport::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  test "ranking in men single series" do
    # assert_equal 2, PlaySeries.count
    plm= play_series(:singleMen)
    assert_equal "Herren D", plm.series_string
    assert_equal "Zwurgel Urgel", plm.list_name
    assert_equal 1, plm.series_ranking
    plw= play_series(:singleMenForWoman)
    assert_equal "Herren D", plw.series_string
    assert_equal "Zwargel Margel", plw.list_name
    assert_equal 1, plw.series_ranking
  end

  test "ranking in women single series" do
    plw=play_series(:singleWomen)
    assert_equal "Damen D", plw.series_string
    assert_equal "Zwargel Margel", plw.list_name
    assert_equal 3, plw.series_ranking
  end

  test "men double entry" do
    pld=play_series(:doubleMen)
    assert_equal "Herren Doppel C/D (Zworgel Orgel)", pld.series_string
    assert_equal "Zwurgel Urgel/Zworgel Orgel", pld.list_name
    assert_equal DoubleSeries, pld.series.class
    assert_equal 7, pld.ranking
  end

  test "women double entry properties" do
    pld=play_series(:doubleWomen)
    assert_equal "Damen Doppel C/D (Zwirgel Mirgel)", pld.series_string
    assert_equal "Zwargel Margel/Zwirgel Mirgel", pld.list_name
    assert_equal DoubleSeries, pld.series.class
    assert_equal 12, pld.ranking
  end

  test "mixed double entry properties" do
    plm=play_series(:doubleMixed)
    assert_equal "Mixed Doppel C/D (Zwirgel Mirgel)", plm.series_string
    assert_equal "Zwurgel Urgel/Zwirgel Mirgel", plm.list_name
    assert_equal MixedSeries, plm.series.class
    assert_equal 10, plm.ranking
  end

  test "rank in women single series" do
    assert_equal 20, play_series(:womenA).rank
  end

  test "rank in men single series" do
    assert_equal 50, play_series(:menA).rank
    assert_nil play_series(:womanInMenA).rank
  end

  test "rank and ranking in double entry" do
    pld=play_series :doubleWomenA
    assert_nil pld.rank
    assert_equal 37, pld.ranking
  end

  test "rank in mixed double entry" do
    plx=play_series(:doubleMixedA)
    assert_equal 38, plx.ranking
    assert_nil plx.rank
  end

  test "diplay_ranking men" do
    assert_equal "1", play_series(:singleMen).display_ranking
    assert_equal "1", play_series(:singleMenForWoman).display_ranking
    assert_equal "18 (50)", play_series(:menA).display_ranking
    assert_equal "18 (51)", play_series(:strongWomanInMenA).display_ranking
  end

  test "display_ranking women" do
    assert_equal "3", play_series(:singleWomen).display_ranking
    assert_equal "20 (2)", play_series(:strongWomanInWomenA).display_ranking
  end

  test "comparison" do
    assert play_series(:menA)<play_series(:womanInMenA)
    assert play_series(:menA)<play_series(:strongWomanInMenA)
    assert play_series(:raiserMenA)<play_series(:menA)
    assert play_series(:elite)<play_series(:eliteRaiser)
  end
end