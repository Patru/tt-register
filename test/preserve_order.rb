#encoding: UTF-8

require 'minitest/assertions'

module Minitest::Assertions
  #
  #  Fails unless +expected and +actual have the same items.
  #
  def assert_preserve_order(earlier, later)
    assert same_items(earlier, later),
           "Expected #{ expected.inspect } and #{ actual.inspect } to have the same items"
  end

  private

  def preserve_order?(earlier, later)

  end
end