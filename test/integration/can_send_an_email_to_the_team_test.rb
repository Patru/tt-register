#encoding: UTF-8
require "test_helper"

# To be handled correctly this spec must end with "Integration Test"
describe "CanSendAnEmailToTheTeam Integration Test" do
  it "can submit an email form without login" do
    visit "/"
    click_link "Turnier-Team eine E-Mail schicken"
    clear_emails
    within 'form#new_email' do
      fill_in 'Von:', with: 'sender@nowhere.near'
      fill_in 'Betreff:', with: 'I want to say something'
      fill_in 'Text:', with: 'I just do not know what exactly'
      click_button 'Email abschicken'
    end
    all_emails.count.must_equal 1
    current_mail = all_emails.last
    current_mail.to.count.must_equal 1
    current_mail.to[0].must_equal tournaments(:one).sender_email
    current_mail.subject.wont_be_nil
    current_mail.body.wont_be_nil
    within 'div.notice' do
      page.must_have_content 'Herzlichen Dank, die Email wurde dem Turnier-Team zugestellt, es wird sich bei Bedarf melden.'
    end
  end
end
