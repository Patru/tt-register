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
    select inscription_day.day, from: 'tournament_day_last_inscription_time_3i'
    within '#tournament_day_last_inscription_time_2i' do
      find("option[value='#{inscription_day.month}']").click
    end
    select inscription_day.year, from: 'tournament_day_last_inscription_time_1i'
    select 20, from: 'tournament_day_last_inscription_time_4i'
    select "00", from: 'tournament_day_last_inscription_time_5i'
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
      click_link 'Serien'
    end
    within 'div#menu ul.context' do
      click_link 'Neue Serie'
    end
    within 'form.new_series' do
      select "Dummy Twelve Turnier: Samstag (#{day_string})", from:'series_tournament_day_id'
      fill_in 'Kürzel:', with: 'MDAllSa'
      fill_in 'Name:', with:'Alle'
      select '11', from:'series_start_time_4i'
      select '00', from:'series_start_time_5i'
      fill_in 'Klassierung von:', with:'1'
      fill_in 'series_max_ranking', with:'20'
      click_button 'speichern'

      select "Dummy Twelve Turnier: Sonntag (#{sunday.strftime('%d.%m.%Y')})", from:'series_tournament_day_id'
      fill_in 'Kürzel:', with: 'MDAllSo'
      fill_in 'Name:', with:'Alle'
      select '09', from:'series_start_time_4i'
      select '00', from:'series_start_time_5i'
      fill_in 'Klassierung von:', with:'1'
      fill_in 'series_max_ranking', with:'20'
      click_button 'speichern'
    end
  end

end
