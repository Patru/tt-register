ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
MiniTest::Rails.override_testunit!

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
