#encoding: UTF-8
require "test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "CanHandleWaitingList Integration Test" do
  self.use_transactional_fixtures = false
  before do
    @player = players :ten
    Capybara.current_driver = :webkit
    new_inscription_with_name("this is a nickname")
    add_player_to_inscription(@player)
  end

  after do
    Capybara.use_default_driver
  end

  it "adds a player to the inscription even if the day is full" do
    page.must_have_content 'Samstag: 19/19'
    player = players :eleven
    clear_emails
    add_player_to_inscription(player)
    open_email @inscription.email
    waiting_list_text = 'Warteliste Sa: 1'
    current_email.must_have_content "#{player.name} wurde auf deiner Einschreibung " +
                                        "folgendermassen angemeldet: #{waiting_list_text}"
    within 'table#my_inscriptions' do
      page.must_have_link(player.name)
      page.must_have_content waiting_list_text
    end
  end

  it "informs the top waiting-list player that he can participate if there is a deregistration" do
    surplus_player = players :eleven
    add_player_to_inscription surplus_player
    clear_emails
=begin
  later versions of capybara would allow this:
   msg=page.accept_confirm do
      signoff_link=first(:link, 'Abmelden')
      signoff_link.click
    end
=end
  msg=page.driver.accept_modal :confirm do
    signoff_link=first(:link, 'Abmelden')
    signoff_link.click
  end
  msg.must_equal "Soll Noch Nicht Angemeldet wirklich abgemeldet werden?"

    # if the above fails without a dialog your application.js might be broken,
    # start a local server and check your console to figure out why.
    page.must_have_content "#{@player.name} wurde abgemeldet"
    within 'table#my_inscriptions' do
      page.must_have_content surplus_player.long_name
      page.must_have_content "Herren D"
      page.wont_have_content @player.long_name
    end
    all_emails.count.must_equal 2

    emails_sent_to @inscription.email
    first_mail = current_emails[0]
    first_mail.to.count.must_equal 1
    first_mail.to[0].must_equal @inscription.email
    first_mail.subject.must_equal "Abmeldung von #{@player.long_name}"
    first_mail.must_have_content "#{@player.long_name} wurde aus deiner Einschreibung gelöscht"
        # Nokogiri will fix quoted printable encoding
    second_mail = current_emails[1]
    second_mail.to.count.must_equal 1
    second_mail.to[0].must_equal @inscription.email
    second_mail.subject.must_match "Anmeldung durch Abbau der Warteliste"
    second_mail.must_have_content "#{surplus_player.long_name} ist jetzt wie folgt angemeldet"
  end

  it "can handle the waiting lists of multiple tournament days" do
    skip
  end
end
