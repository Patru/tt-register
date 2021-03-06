#encoding: UTF-8
require 'test_helper'
require 'views/series/listers/standard'

class SeriesTest < ActiveSupport::TestCase
  test "ranking of players in men series" do
    men_single=series(:menD)
    assert_equal 1, men_single.ranking_of(players(:one))
    assert_equal 1, men_single.ranking_of(players(:two))
  end

  test "ranking of players in women series" do
    women_double=series(:womenDouble)
    assert_nil women_double.ranking_of(players(:one))
    assert_equal 3, women_double.ranking_of(players(:two))
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

  test "rank of players in women series" do
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

  test "play_series returns all the players" do
    assert_equal 2, series(:menD).play_series.size
    assert_equal 3, series(:menDouble).play_series.size
  end

  test "playing returns every playing entity only once" do
    assert_equal 2, series(:menD).playing.size
    assert_equal 1, series(:menDouble).playing.size
  end

  test "open returns all open players who will build full entities" do
    assert_equal 0, series(:menD).open.size
    assert_equal 1, series(:menDouble).open.size
  end

  test "validates presence of min and max rankings" do
    s=Series.new
    refute s.valid?
    refute Series.new(min_ranking: 1, max_ranking: 15).valid?
    assert Series.new(min_ranking: 1, max_ranking: 15, category:"").valid?
  end

  test "valid Series must be comparable" do
    s0=Series.new(min_ranking: 1, max_ranking: 15, category:"")
    s1=Series.new(min_ranking: 1, max_ranking: 20, category:"")
    assert_equal 1, s0<=>s1
  end

  it "can translate men in name" do
    men=Series.new(long_name: "Herren A20")
    I18n.locale=:de
    men.translated_name.must_equal "Herren A20"
    I18n.locale=:en
    men.translated_name.must_equal "Men A20"
    I18n.locale=:fr
    men.translated_name.must_equal "Messieurs A20"
  end

  it "can translate women in name" do
    women=Series.new(long_name: "Damen B15")
    I18n.locale=:de
    women.translated_name.must_equal "Damen B15"
    I18n.locale=:en
    women.translated_name.must_equal "Women B15"
    I18n.locale=:fr
    women.translated_name.must_equal "Dames B15"
  end

  it "can translate men's doubles in name" do
    doubles=Series.new(long_name: "Herren Doppel A/B")
    I18n.locale=:de
    doubles.translated_name.must_equal "Herren Doppel A/B"
    I18n.locale=:en
    doubles.translated_name.must_equal "Men's Doubles A/B"
    I18n.locale=:fr
    doubles.translated_name.must_equal "Double messieurs A/B"
  end

  it "can translate women's doubles in name" do
    doubles=Series.new(long_name: "Damen Doppel A/B")
    I18n.locale=:de
    doubles.translated_name.must_equal "Damen Doppel A/B"
    I18n.locale=:en
    doubles.translated_name.must_equal "Women's Doubles A/B"
    I18n.locale=:fr
    doubles.translated_name.must_equal "Double dames A/B"
  end

  it "can translate mixes doubles in name" do
    doubles=Series.new(long_name: "Mixed Doppel A/B")
    I18n.locale=:de
    doubles.translated_name.must_equal "Mixed Doppel A/B"
    I18n.locale=:en
    doubles.translated_name.must_equal "Mixed Doubles A/B"
    I18n.locale=:fr
    doubles.translated_name.must_equal "Double mixte A/B"
  end

  it 'accepts inscriptions based on the current time' do
    tour_day = TournamentDay.new(last_inscription_time: (Time.now+100))
    ser = tour_day.series.build()
    ser.tournament_day = tour_day    # this will usually happen during save
    ser.must_be :accepting_inscriptions?
    tour_day.last_inscription_time=(Time.now-1)
    ser.wont_be :accepting_inscriptions?
  end

  it 'knows when it is time not to accept an inscription anymore' do
    o60=series(:too_late)
    o60.wont_be :accepting_inscriptions?
  end

  describe "handling of Elo series" do
    it "can specify a minimal Elo number for inscription" do
      elo_sa = series(:elo_sa)
      elo_sa.min_elo=999
      elo_sa.slack_elo=200
      elo_sa.slack_days=10

      elo_so = series(:elo_so)
      elo_so.max_elo=1500
    end
    describe "naming in german" do
      before do
        @was=I18n.locale
        I18n.locale=:de
        @elo_sa = series(:elo_sa)
      end
      after do
        I18n.locale=@was
      end

      it "abbreviates for navigation" do
        @elo_sa.nav_name.must_equal "Elo 12-er Sa"
      end
    end

    describe "naming in french" do
      before do
        @was=I18n.locale
        I18n.locale=:fr
        @elo_sa = series(:elo_so)
      end
      after do
        I18n.locale=@was
      end

      it "abbreviates for navigation" do
        @elo_sa.nav_name.must_equal "Elo à 12 dim"
      end
    end
  end

  describe "naming in english" do
    before do
      @was=I18n.locale
      I18n.locale=:en
      @elo_so = series(:elo_so)
    end
    after do
      I18n.locale=@was
    end

    it "abbreviates for navigation" do
      @elo_so.nav_name.must_equal "Elo twelver Sun"
    end
  end

  describe "listers" do
    it "provides a default class for listing all players" do
      Series.new.lister.wont_be_nil
      series(:elite).lister.wont_equal series(:elo_so).lister
    end
  end

  describe "system links" do
    before do
      I18n.locale=:de
    end
    after do
      I18n.locale=:de
    end
    it 'can have system explanation links in 3 languages' do
      elo_sa=series(:elo_sa)
      elo_so=series(:elo_so)
      elo_sa.sys_exp_link.must_equal "http://www.ysz.ch/turnier/spielsystem_de.html"
      elo_so.sys_exp_link.must_equal "http://www.ysz.ch/turnier/spielsystem_de.html"
      I18n.locale=:en
      elo_sa.sys_exp_link.must_equal "http://www.ysz.ch/turnier/spielsystem_de.html"
      elo_so.sys_exp_link.must_equal "http://www.ysz.ch/turnier/spielsystem_en.html"
      I18n.locale=:fr
      elo_sa.sys_exp_link.must_equal "http://www.ysz.ch/turnier/spielsystem_de.html"
      elo_so.sys_exp_link.must_equal "http://www.ysz.ch/turnier/spielsystem_fr.html"
    end
  end
end
