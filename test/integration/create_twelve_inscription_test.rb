#encoding: UTF-8
require "test_helper"

describe "Create and inscriction for a Twelve Tournament Integration Test" do
  before do

  end

  it 'can create an inscription' do
    new_inscription_with_licence(700011, DUMMY_EMAIL, :de, 'Dummy Twelve-Tournament')
    save_page "twelve_inscription.html"
    page.must_have_text 'Elo 1050'
  end
end
