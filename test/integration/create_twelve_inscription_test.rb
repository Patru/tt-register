#encoding: UTF-8
require "test_helper"

describe "Create and inscriction for a Twelve Tournament Integration Test" do
  before do

  end

  it 'can create an inscription' do
    new_inscription_with_licence(700034, DUMMY_EMAIL, :de, 'Dummy Twelve-Tournament')
    page.must_have_text 'Elo 1050'
    within 'div#maincontent' do
      within find('tr', text: 'Samstag') do
        page.must_have_text 'ab 999'
        check "Elo Zwölferserie ab 999"
      end
      within find('tr', text: 'Sonntag') do
        page.must_have_text 'bis 1500'
      end
      page.wont_have_text 'Weitere Anmeldungen'
      click_button 'Anmelden'
    end

    within 'form#sel_player' do
      fill_in 'crit[club]', with:'heiner'
      click_button 'Auswählen'
    end
    save_page "player_list.html"
    within 'table.players' do
      click_link 'Zwargel Margel'
    end
    page.must_have_text 'Elo 660'
    within 'form#enrollments' do
      within find('tr', text:'Samstag') do
        page.wont_have_selector 'checkbox' # there should actually be a checkbox, but it must be disabled
                                           # which can only be checked with capybara 2.1
                                           # where it would be  must_have_selector 'checkbox', disabled:true
      end
      within find('tr', text:'Sonntag') do
        check 'Elo Zwölferserie bis 1500'
      end
      click_button 'Anmelden'
    end
    within 'ul#series' do
      click_link 'Elo 12-er Sa'
    end
    within 'table.players_list tbody' do
      within find('tr', text: 'Freefrom') do
        page.must_have_text '1050'
      end
    end
    save_page "twelve_inscription.html"
  end
end
