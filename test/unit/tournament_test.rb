require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  it "must know about the end of inscriptions" do
    tournament = Tournament.new
    puts tournament.methods.select do |m| m.match /accept/ end.to_a
    tournament.must_respond_to :accept_inscriptions_until
  end

  it 'knows the day_spread of a tournament' do
    tournament = Tournament.new
    tournament.day_spread.must_equal 0
    tournament.tournament_days.build(day:Date.new(2013, 11, 17))
    tournament.day_spread.must_equal 1
    tournament.tournament_days.build(day:Date.new(2013, 11, 23))
    tournament.day_spread.must_equal 7
  end
end
