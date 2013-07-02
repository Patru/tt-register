require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  it "must now about the end of inscriptions" do
    tournament = Tournament.new
    puts tournament.methods.select do |m| m.match /accept/ end.to_a
    tournament.must_respond_to :accept_inscriptions_until
  end
end
