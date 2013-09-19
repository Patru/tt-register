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
end
