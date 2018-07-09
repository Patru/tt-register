# encoding: UTF-8
require 'test_helper'
require 'views/layouts/sw_page'

class SWPageTest < ActionView::TestCase
  fixtures []

  def is_admin?
    false
  end

  before do
    @page = Views::Layouts::SWPage.new
    # I still think this is hacky, but it gets the job done for the moment. Maybe a better helpers-object would do?
    class << @page    # create a minimal railsy context to allow the page to find helpers and stuff like that
      extend ActiveSupport::Configurable::ClassMethods
      include ActionController::RequestForgeryProtection
      include Rails.application.routes.url_helpers
    end
  end

  it 'will render in english by default' do
    I18n.locale=:en         # rails-default will be :de, default-default :en, have to set to run alone and in context
    html_text = @page.to_html(prettyprint: true, helpers: self)
    node = Capybara.string html_text
    # for a random reason I don not understand must_have_selector('div#menu')
    node.has_selector?('div#menu').must_equal true
    node.find('div#menu ul.context').has_link?("New inscription form").must_equal true
    node.find('div#menu ul.standard').has_link?("e-mail").must_equal true
    node.find('div#menu ul.standard').has_link?("privacy").must_equal true
    node.find('div#navigation').has_select?('language', selected:'English').must_equal true
  end

  it 'will render in German when locale is set to :de' do
    I18n.locale=:de
    node = Capybara.string @page.to_html(prettyprint: true, helpers: self)
    node.has_selector?('div#menu').must_equal true
    node.find('div#menu ul.context').has_link?("Neues Anmeldekonto").must_equal true
    node.find('div#menu ul.standard').has_link?("E-Mail").must_equal true
    node.find('div#menu ul.standard').has_link?("Datenschutz").must_equal true
    node.find('div#navigation').has_select?('language', selected:'Deutsch').must_equal true
  end
end