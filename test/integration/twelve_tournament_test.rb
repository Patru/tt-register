#encoding: UTF-8
require "test_helper"

def add_tournament_day(tournament_name, day, inscription_day, max)
  within 'div#navigation ul#admin' do
    click_link 'Turniertage'
  end
  within 'div#menu ul.context' do
    click_link 'Neuer Tag für Turnier'
  end
  within 'form.new_tournament_day' do
    select tournament_name, from: 'tournament_day[tournament_id]'
    fill_date_in 'tournament_day_day', with: day
    fill_in 'tournament_day_max_inscriptions', with: max
    fill_date_time_in 'tournament_day_last_inscription_time', with:inscription_day
    click_button 'Erzeugen'
  end
  within 'div.notice' do
    page.must_have_text 'TournamentDay was created successfully'
  end
end

# To be handled correctly this spec must end with "Integration Test"
describe "Twelve Tournament Integration Test" do
  before do
#    Capybara.current_driver = :webkit
    create_initial_admin_and_login
    # note that this will create a transaction that will only be finished after your test case
    # It won't be seen by WebKit unless you monkey patch the framework to use a single connection.
  end

  after do
    Capybara.use_default_driver
    set_browser_language 'de-CH'
  end
  it "can can set up a tournament" do
    within 'div#navigation ul#admin' do
      click_link "Turniere"
    end
    within 'div#menu ul.context' do
      click_link 'Neues Turnier'
    end
    future=Date.today+35
    friday=DateTime.commercial(future.year, future.cweek, 5, 20, 1)
    saturday=Date.commercial(future.year, future.cweek, 6)
    sunday=Date.commercial(future.year, future.cweek, 7)
    day_string = saturday.strftime('%d.%m.%Y')
    within 'form.new_tournament' do
      fill_in 'tournament[tour_id]', with: 'Dm12'
      fill_in 'tournament[name]', with: 'Dummy Twelve Turnier'
      fill_in 'tournament[date]', with: day_string
      fill_in 'tournament[organiser]', with: 'nobody'
      fill_in 'tournament[sender_email]', with: 'nobody@nowhere.net'
      fill_date_time_in 'tournament_last_inscription_time', with: friday
      fill_in 'tournament[thanks_for_interest_de]', with: 'am Dummy Twelve Turnier'
      click_button 'Erzeugen'
    end
    page.wont_have_content "Internal Server Error"
    within 'div.notice' do
      page.must_have_text 'Tournament was created successfully'
    end

    add_tournament_day('Dummy Twelve Turnier', saturday, friday, 10)
    add_tournament_day('Dummy Twelve Turnier', sunday, friday, 20)
    within 'div#navigation ul#admin' do
      click_link 'Turniertage'
    end
    within 'div#maincontent table' do
      within find('tr', text: saturday.to_s) do
        click_link 'Details anzeigen'
        page.wont_have_text 'Serien'
      end
    end
    within 'div#navigation ul#admin' do
      click_link 'Serien'
    end
    within 'div#menu ul.context' do
      click_link 'Neue Serie'
    end
    within 'form.new_series' do
      select "Dummy Twelve Turnier: Samstag (#{day_string})", from:'series_tournament_day_id'
      fill_in 'Kürzel:', with: 'EloSa'
      fill_in 'Name:', with:'Zwölferserien Samstag'
      select '11', from:'series_start_time_4i'
      select '00', from:'series_start_time_5i'
      fill_in 'Klassierung von:', with:'1'
      fill_in 'series_max_ranking', with:'20'
      fill_in 'Elo Minimum:', with:999
      fill_in 'Typ', with: 'Elo'
      click_button 'speichern'
    end

    page.must_have_text "Serie erfolgreich erzeugt."
    page.must_have_text "999"
    within 'div#navigation ul#admin' do
      click_link 'Serien'
    end
    within 'div#menu ul.context' do
      click_link 'Neue Serie'
    end
    within 'form.new_series' do
      select "Dummy Twelve Turnier: Sonntag (#{sunday.strftime('%d.%m.%Y')})", from:'series_tournament_day_id'
      fill_in 'Kürzel:', with: 'EloSo'
      fill_in 'Name:', with:'Zwölferserien Sonntag'
      select '09', from:'series_start_time_4i'
      select '00', from:'series_start_time_5i'
      fill_in 'Klassierung von:', with:'1'
      fill_in 'series_max_ranking', with:'20'
      fill_in 'Elo Maximum', with:1500
      fill_in 'Typ', with: 'Elo'
      click_button 'speichern'
    end
    page.must_have_text "1500"
    page.must_have_text "Serie erfolgreich erzeugt."
    within 'div#navigation ul#admin' do
      click_link 'Turniertage'
    end
    within 'div#maincontent table' do
      within find('tr', text: saturday.to_s) do
        click_link 'Details anzeigen'
      end
    end
    within 'h2' do
      page.must_have_text 'Serien für diesen Tag'
    end
    within 'table.series-list' do
      page.must_have_text 'Zwölferserien Samstag'
    end
    within 'div#navigation ul#admin' do
      click_link 'Turniere'
    end
    within 'div#maincontent table' do
      within find('tr', text: "Dummy Twelve Turnier") do
        click_link "Details anzeigen"
      end
    end
    within 'ul#series' do
      page.must_have_text 'Elo 12-er Sa'
      click_link 'Elo 12-er Sa'
    end
    save_page "series_sa.html"
    within 'div#maincontent table thead' do
      page.wont_have_css('th', text:"Klassierung")
      page.must_have_css 'th', text:'Elo Punkte'
    end
    page.must_have_text 'Elo Zwölferserie ab 999'
    within 'ul#series' do
      page.must_have_text 'Elo 12-er Sa'
      set_browser_language 'fr-fr'
      click_link 'Elo 12-er Sa'
    end
    save_page 'elo_fr.html'
    page.must_have_text 'série Elo à douze à partir de 999'
    within 'ul#series' do
      page.must_have_text 'Elo à 12 sam'
      set_browser_language 'en-gb'
      click_link 'Elo à 12 sam'
    end
    save_page 'elo_en.html'
    page.must_have_text 'Elo twelve series higher than 999'
    within 'ul#series' do
      page.must_have_text 'Elo twelver Sat'
    end

  end
end
