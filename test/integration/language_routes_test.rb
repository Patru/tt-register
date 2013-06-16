# encoding: UTF-8
require File.join(File.dirname(__FILE__), "..", "test_helper")

describe 'Language Routes Integration Test' do

  it 'should be able to route set language' do
    # this will test the next two, but we assert the three anyways
    assert_routing({ path: "/set_language", method: :post }, { controller: "language", action: "set_language" })

    assert_recognizes({ controller: "language", action: "set_language" }, {path: "language/set_language", method: 'post'})
    assert_generates("/language/set_language", { controller: "language", action: "set_language" })
  end
end