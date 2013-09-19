# encoding: UTF-8
require 'test_helper'

class TournamentDayTest < ActiveSupport::TestCase
  it 'knows about the last day for inscriptions' do
    tday=TournamentDay.new(day:Date.new(2013, 11, 16))
    tday.must_respond_to :last_inscription_time
  end

  describe "accept inscriptions until" do
    before do
      @day_end = Time.local 2013, 11, 11, 19, 00
      @tournament_end = Time.local 2013, 11, 10, 18, 00
      @tour=Tournament.new(last_inscription_time:@tournament_end)
    end
    it 'accepts inscriptions according to the tournament without a setting' do
      tour_day=@tour.tournament_days.build()
      tour_day.tournament=@tour   # this would otherwise happen during save
      tour_day.accept_inscriptions_until.must_equal @tournament_end
    end

    it 'accepts inscriptions up to its own setting if it has one' do
      tour_day = TournamentDay.new(last_inscription_time:@day_end)
      tour_day.accept_inscriptions_until.must_equal @day_end
    end

    it 'the day setting suppresses an available tournament setting' do
      tour_day = @tour.tournament_days.build(last_inscription_time:@day_end)
      tour_day.tournament=@tour   # this would otherwise happen during save
      tour_day.accept_inscriptions_until.must_equal @day_end
    end

    it 'will yous tour_day.day if no other dates are set' do
      tour = Tournament.new
      nov1 = Date.new(2013, 11, 1)
      tour_day = tour.tournament_days.build(day:nov1)
      tour_day.tournament = tour   # this would otherwise happen during save
      tour_day.accept_inscriptions_until.must_equal nov1.to_time
    end
  end
end