require 'test_helper'

class InscriptionsControllerTest < ActionController::TestCase
  it "must set the locale given a decent header" do
    @request.headers['ACCEPT_LANGUAGE'] = 'fr_FR'
    @request.env['HTTP_ACCEPT_LANGUAGE'] = 'fr_FR'
    @request.env["HTTP_ACCEPT_LANGUAGE"] = "en"
    get 'new'
    assert_response :success
    I18n.locale.must_equal :fr
    session[:locale].must_be_nil
  end
end
