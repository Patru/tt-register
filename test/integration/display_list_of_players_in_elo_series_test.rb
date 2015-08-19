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
  end

  it "displays starting date and starting time" do
    elo_sa = series :elo_sa
    puts elo_sa.start_time
    page.must_have_text I18n.localize(elo_sa.day_time, format: '%e. %B %Y, %H:%M')
  end

  it "provides provisional grouping info" do
    within 'div.series-start' do
      page.must_have_link "Spielsystem", href:"http://www.ysz.ch/turnier/spielsystem_de.html"
    end
    within 'table.players_list' do
      within 'thead' do
        within 'th[colspan="2"]' do
          page.must_have_text 'Serie (provisorisch)'
        end
      end
      within 'tbody' do
        page.must_have_css('tr.in', count:9)
        within find('tr.first') do
          page.must_have_text 'Ron Raiser'
        end
        within find('td.series-name') do
          page.must_have_text "Serie 1"
        end
        within find('tr.last') do
          page.must_have_text "Einer Zuviel"
        end
      end
    end
    save_page "prov_series.html"
    set_browser_language 'fr-FR'
    within 'ul#series' do
      click_link 'Elo 12-er Sa'
    end
    within 'div.series-start' do
      page.must_have_link "mode des jeux"
    end
    within 'table.players_list' do
      within 'thead th[colspan="2"]' do
        page.must_have_text 'Série (provisoire)'
      end
      within 'tbody td.series-name' do
        page.must_have_text 'Série 1'
      end
    end
    set_browser_language 'en-GB'
    within 'ul#series' do
      click_link 'Elo à 12 sam'
    end
    within 'div.series-start' do
      page.must_have_link "system of play"
    end
    within 'table.players_list' do
      within 'thead th[colspan="2"]' do
        page.must_have_text 'Series (provisional)'
      end
      within 'tbody td.series-name' do
        page.must_have_text 'Series 1'
      end
    end
  end
end