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
describe "Invitation Tournament Integration Test" do
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
    sunday=Date.commercial(future.year, future.cweek, 7)
    day_string = sunday.strftime('%d.%m.%Y')
    within 'form.new_tournament' do
      fill_in 'tournament[tour_id]', with: 'Invi'
      fill_in 'tournament[name]', with: 'Invitation tournament'
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
      select "Invitation tournament: Sunday (#{day_string})", from:'series_tournament_day_id'
      fill_in 'Kürzel:', with: 'MU13'
      fill_in 'Name:', with:'Knaben U13'
      select '9', from:'series_start_time_4i'
      select '30', from:'series_start_time_5i'
      fill_in 'Klassierung von:', with:'1'
      fill_in 'series_max_ranking', with:'20'
      click_button 'speichern'
    end

    page.must_have_text "Serie erfolgreich erzeugt."
    page.must_have_text "Knaben U13"

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
      within find('tr', text: "Einladungsturnier") do
        click_link "Details anzeigen"
      end
    end
    within 'ul#series' do
      page.must_have_text 'Knaben U13'
      click_link 'Knaben U13'
    end
    save_and_open_page

  end
end
