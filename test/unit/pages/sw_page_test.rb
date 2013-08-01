# encoding: UTF-8
require 'test_helper'
require 'views/layouts/sw_page'

class SWPageTest < ActionView::TestCase
  include Capybara::RSpecMatchers
  fixtures []

  before do
    @page = Views::Layouts::SWPage.new
    # I still think this is hacky, but it gets the job done for the moment. Maybe a better helpers-object would do?
    class << @page    # create a minimal railsy context to allow the page to find helpers and somesuch
      extend ActiveSupport::Configurable::ClassMethods
      include ActionController::RequestForgeryProtection
      include Rails.application.routes.url_helpers
    end
  end

  it 'will render in english by default' do
    html_text = @page.to_html(prettyprint: true, helpers: self)
    node = Capybara.string html_text
    node.must_have_selector('div#menu')
    node.find('div#menu ul.context').must_have_link("New inscription")
    node.find('div#menu ul.standard').must_have_link("e-mail")
    node.find('div#menu ul.standard').must_have_link("privacy")
    node.find('div#navigation').must_have_select('language', selected:'English')
  end

  it 'will render in German when locale is set to :de' do
    I18n.locale=:de
    node = Capybara.string @page.to_html(prettyprint: true, helpers: self)
    node.must_have_selector('div#menu')
    node.find('div#menu ul.context').must_have_link("Neue Einschreibung")
    node.find('div#menu ul.standard').must_have_link("E-Mail")
    node.find('div#menu ul.standard').must_have_link("Datenschutz")
    node.find('div#navigation').must_have_select('language', selected:'Deutsch')
  end
end