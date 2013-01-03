#encoding: UTF-8
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'minitest/autorun'
require "minitest/rails"
require "minitest/reporters"
require 'capybara/email'

MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

require "minitest/rails/capybara"
require "minitest/pride"

I18n.locale = :en

class MiniTest::Rails::ActiveSupport::TestCase
  fixtures :all
end

class MiniTest::Rails::ActionDispatch::IntegrationTest
  include Capybara::Email::DSL
  DUMMY_EMAIL = "nobody@nowhere.net"

  def create_admin_user
    post :create, :admin => {name:"Test", password:"blank", email: "test_email", token:"blabla" }
  end

  def email_link_path(email)
    email.body.match(/http:\/\/[^\/]+(\S+)/)[1]
  end

  def new_inscription_with_licence(licence, email=DUMMY_EMAIL)
    visit "/"
    clear_emails
    within "form#new_inscription" do
      fill_in "inscription_licence", with: licence
      fill_in "inscription[email]", with: email
      click_button 'Einschreibung erstellen'
    end
    open_email email
    visit email_link_path(current_email)
    @inscription = Inscription.where(licence: licence).first
    page.must_have_content "#{@inscription.name} eingeloggt!"
  end

  def new_inscription_with_name(name, email=DUMMY_EMAIL)
    visit "/"
    clear_emails
    within "form#new_inscription" do
      fill_in "Name", with: name
      fill_in "E-mail", with: email
      click_button 'Einschreibung erstellen und Email-Adresse bestätigen'
    end
    open_email email
    visit email_link_path(current_email)
    @inscription = Inscription.where(name: name).first
    page.must_have_content "#{@inscription.name} eingeloggt!"
  end

  def add_player_to_inscription(player, series = 'rb_1')
    within "form#licence" do
      fill_in "licence", with: player.licence
      click_button "Hinzufügen"
    end
    choose(series)
    click_button 'Anmelden'
    click_link @inscription.name
  end
end

def accept_js_alert
  page.driver.browser.switch_to.alert.accept
end

class Capybara::Session
  def link_with_text(text)
    all(:link, text).select do |elt| elt.text.eql? text end.first
  end
end