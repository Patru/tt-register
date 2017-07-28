require "test_helper"

describe "LanguageController" do
  #class LanguageControllerTest < ActionController::TestCase
  it "must not set the locale without parameter" do
    post :set_language
    assert_redirected_to root_path
    I18n.locale.must_equal :de
    session[:locale].must_be_nil
  end

  it "must set the locale given a valid language" do
    post :set_language, parameters={language: 'de'}
    assert_redirected_to root_path
    I18n.locale.must_equal :de
    :de.must_equal session[:locale]
  end
end
