#encoding: UTF-8
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'minitest/autorun'
require "rails/test_help"
require "capybara/rails"
require 'capybara_minitest_spec'

require "minitest/reporters"
require 'capybara/email'

MiniTest::Reporters.use!

require "capybara/rspec/matchers"
require "minitest/matchers"
require "minitest/rails/capybara"
require "minitest/pride"

I18n.locale = :de

Capybara.save_and_open_page_path=Rails.root.join("screenshots")

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Assertions      # we should not need to include this on our own, there must be a better way
  include Capybara::Email::DSL
  DUMMY_EMAIL = "nobody@nowhere.net"

  def create_admin_user
    post :create, :admin => {name:"Test", password:"blank", email: "test_email", token:"blabla" }
  end

  def email_link_path(email)
    email.body.match(/http:\/\/[^\/]+(\S+)/)[1]
  end

  def set_browser_language language
    if Capybara.current_driver == :webkit
      page.driver.header 'Accept-Language', language
    end
  end

  def new_inscription_with_licence(licence, email=DUMMY_EMAIL, language=:de)
    set_browser_language language
    visit "/"
    clear_emails
    within "form#new_inscription" do
      fill_in "inscription_licence", with: licence
      fill_in "inscription[email]", with: email
      click_button 'create_inscription'
    end
    open_email email
    visit email_link_path(current_email)
    @inscription = Inscription.where(licence: licence).first
    page.must_have_content "#{@inscription.name} ist jetzt eingeloggt!"
  end

  def new_inscription_with_name(name, email=DUMMY_EMAIL, language=:de)
    set_browser_language language
    visit "/"
    clear_emails
    within "form#new_inscription" do
      fill_in "inscription[name]", with: name
      fill_in "inscription[email]", with: email
      click_button 'create_inscription'
    end
    within 'div.notice' do
      # this will wait long enough for the mail to "arrive" even in webkit
    end
    all_emails.count.must_equal 1
    open_email email
    visit email_link_path(current_email)
    @inscription = Inscription.where(name: name).first
    page.must_have_content "#{@inscription.name} ist jetzt eingeloggt!"
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

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  TEST_EMAIL= "NoAdmin@no.where"
  def store_an_admin_user
    admin=Admin.new(name:"Test", password:"blank", email:TEST_EMAIL, token:"blabla")
    admin.save
    Admin.last
  end

  def create_admin_user
    post :create, :admin => {name:"Test", password:"blank", email:TEST_EMAIL, token:"blabla" }
    Admin.last
  end

  def create_and_login_dummy_admin
    test_admin=create_admin_user
    email = ActionMailer::Base.deliveries.last
    link=email.encoded.match(/(https?:\/\/[\S]+)/)[0]
    post :verify_login, :admin => { token:"blabla", password:"blank"}
    test_admin
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

# put this in your test_helper.rb if you encounter the following error:

# NoMethodError: undefined method `failure_message' for Capybara::Helpers:Module
# (eval):19:in `block in assert_link'

# when using minitest-capybara with capybara 2.0.3 e.g. if you are stuck on Ruby 1.9.2
# and you will have decent error messages again

# (stolen from Capybara 2.1.0 on which minitest-capybara implicitely depends)
module Capybara
  module Helpers
    extend self
    ##
    #
    # Generates a failure message given a description of the query and count
    # options.
    #
    # @param [String] description   Description of a query
    # @option [Range] between       Count should have been within the given range
    # @option [Integer] count       Count should have been exactly this
    # @option [Integer] maximum     Count should have been smaller than or equal to this value
    # @option [Integer] minimum     Count should have been larger than or equal to this value
    #
    def failure_message(description, options={})
      message = "expected to find #{description}"
      if options[:count]
        message << " #{options[:count]} #{declension('time', 'times', options[:count])}"
      elsif options[:between]
        message << " between #{options[:between].first} and #{options[:between].last} times"
      elsif options[:maximum]
        message << " at most #{options[:maximum]} #{declension('time', 'times', options[:maximum])}"
      elsif options[:minimum]
        message << " at least #{options[:minimum]} #{declension('time', 'times', options[:minimum])}"
      end
      message
    end
  end
end