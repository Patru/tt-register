#encoding: UTF-8
require "test_helper"

describe "maintain parallel tournaments Integration Test" do
  before do
    create_initial_admin_and_login
    @tour1=Tournament.new(tour_id: 'OTTM', name: 'Ostschweizer Meisterschaft', date: Date.today+5,
                          organiser: 'OTTV', sender_email: 'nobody@ottv.ch',
                          thanks_for_interest_de: 'an der OTTM')
    @tour1.save
    @tour2=Tournament.new(tour_id: 'NWRLQ', name: 'Nachwuchs Ranglisten Qualifikation', date: Date.today+10,
                          organiser: 'STT', sender_email: 'nobody@swisstabletennis.ch',
                          thanks_for_interest_de: 'an der Ranglisten Qualifikation')
    @tour2.save
  end

  after do
    Capybara.use_default_driver
    set_browser_language 'de-CH'
  end

  it "displays both new tournaments in the initial select" do
    visit root_url
    within 'form#new_inscription' do
      page.must_have_select('inscription_tournament_id',
                            with_options:['Ostschweizer Meisterschaft', 'Nachwuchs Ranglisten Qualifikation'])
      page.must_have_select('inscription_tournament_id', selected: 'Zürich Open')
    end
  end

  it 'selects the correct tournament when surfed with the right URL' do
    tour_with_id_path('ottm').must_equal '/ottm'

    visit tour_with_id_url 'ottm'

    save_page 'home.html'
    within '#tournament_header' do
      page.must_have_text 'Ostschweizer Meisterschaft'
    end
  end
end
