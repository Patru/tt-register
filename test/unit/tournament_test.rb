# encoding: UTF-8
require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  before do
    @tournament = Tournament.new
  end
  it "must know about the end of inscriptions" do
    puts @tournament.methods.select do |m| m.match /accept/ end.to_a
    @tournament.must_respond_to :accept_inscriptions_until
  end

  it 'knows the day_spread of a tournament' do
    tournament = Tournament.new
    tournament.day_spread.must_equal 0
    tournament = Tournament.new   #redo Tournament, the value of @days remains cached
    tournament.tournament_days.build(day:Date.new(2013, 11, 17))
    tournament.day_spread.must_equal 1
    @tournament.tournament_days.build(day:Date.new(2013, 11, 17))
    @tournament.tournament_days.build(day:Date.new(2013, 11, 23))
    @tournament.day_spread.must_equal 7
  end

  it 'accepts inscriptions up to the start if nothing is set' do
    tour_day=@tournament.tournament_days.build(day:Date.today)
    tour_day.tournament = @tournament
    tour_day.accept_inscriptions_until.must_equal Date.today.to_time
  end

  it 'can select to only show playable series' do
    @tournament.must_respond_to :only_show_playable_series
    @tournament.only_show_playable_series=true
  end

  it 'can localize the thanks-text' do
    @tournament.thanks_for_interest_en.must_be_nil
    @tournament.thanks_for_interest_en= "Thank you for your interst in the Dummy Grummy Tournament"
    @tournament.thanks_for_interest_de= "Danke für dein Interesse am Dummy Grummy Turnier"
    @tournament.thanks_for_interest_fr= "Merci pour ton intérêt au tournois Dummy Grummy"
    I18n.locale=:de
    @tournament.thanks_for_interest_localized.must_equal  @tournament.thanks_for_interest_de
    I18n.locale=:fr
    @tournament.thanks_for_interest_localized.must_equal  @tournament.thanks_for_interest_fr
    I18n.locale=:en
    @tournament.thanks_for_interest_localized.must_equal  @tournament.thanks_for_interest_en
  end
end
