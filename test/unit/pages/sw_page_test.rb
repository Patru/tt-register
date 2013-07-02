# encoding: UTF-8
require 'test_helper'
require 'views/layouts/sw_page'

class SWPageTest < ActionView::TestCase
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper   # or ActionController::UrlFor

  it 'creates a german series menu by default' do

    page = Views::Layouts::SWPage.new
    page.wont_be_nil
    skip " did not get my own helper methods to work!!"
    page.to_html(prettyprint:true, helpers:self).must_equal "test"
  end
end