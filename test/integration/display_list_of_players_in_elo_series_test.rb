#encoding: UTF-8
require "test_helper"

describe "display list of players in Elo series properly Integration Test" do
  before do
    new_inscription_with_licence(700034, DUMMY_EMAIL, 'de', 'Dummy Twelve-Tournament')
    within 'ul#series' do
      click_link 'Elo 12-er Sa'
    end
  end

  it 'can display the list of players' do
    within 'div#maincontent table.players_list' do
      preserve_order(page, 810, 777)
      preserve_order(page, 993, 810)
      preserve_order(page, 1600, 1200)
      preserve_order(page, 1200, 993)
    end
    save_page 'series_elo_sa.html'
  end

  it "displays starting date and starting time" do
    elo_sa = series :elo_sa
    puts elo_sa.start_time
    save_page "series_sa.html"
    page.must_have_text I18n.localize(elo_sa.day_time, format: '%e. %B %Y, %H:%M')
  end

  it "provides provisional grouping info"
end