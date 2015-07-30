#encoding: UTF-8
require "test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "Can Upload Licence File Integration Test" do
  before do
    create_initial_admin_and_login
  end
  it "can upload a players file" do
    within 'div#navigation ul#admin' do
      click_link "Spieler"
    end
    within 'form#upload' do
      attach_file "players", Rails.root.join("test", "integration", "examples", "sample.csv")
      click_button 'Senden'
    end
    within 'div.notice' do
      page.must_have_text 'Total: 10, geladen: 10, neu: 10'
    end
    page.must_have_text '100033'
    holten = Player.where(licence: 100033).first
    holten.wont_be_nil
    holten.elo.must_equal 973
    page.must_have_text 973
    within 'div#maincontent table' do
      within find('tr', text: 'Holten') do
        click_link 'Details anzeigen'
      end
    #    find(:xpath, "//tr[td[contains(.,'Holten')]]/td/a[@title='Details anzeigen']").click
    #  interesting to know how to do this with an XPath, but the above solution is better.
    end
    within 'div#maincontent table' do
      page.must_have_text 'Elo'
      page.must_have_text '973'
    end
    within 'div#menu ul.context' do
      click_link 'Ändern'
    end

    within 'form.edit_player' do
      fill_in 'player[elo]', with: 975
      click_button 'Ändern'
    end
    within 'div.notice' do
      page.must_have_text 'Der Spieler wurde erfolgreich geändert'
    end
    within find('tr', text: 'Elo Punkte') do
      page.must_have_text 975
    end
  end

  it "can still upload a file without Elo points" do
    within 'div#navigation ul#admin' do
      click_link "Spieler"
    end
    within 'form#upload' do
      attach_file "players", Rails.root.join("test", "integration", "examples", "without_elo.csv")
      click_button 'Senden'
    end
    within 'div.notice' do
      page.must_have_text 'Total: 10, geladen: 10, neu: 10'
    end
    within 'div#maincontent table' do
      within find('tr', text: 'Holten') do
        click_link 'Details anzeigen'
      end
    end

    within find('tr', text: 'Elo Punkte') do
      page.wont_have_text '973'
      page.must_have_text '0'
    end

  end
end
