# encoding: UTF-8

class Verifiers::LayouterParser
  def self.all_subclasses
    self.descendants do |cl| cl.respond_to? :display_name end
    # this will not work after class reloading, always restart the server if you  want to see something in dev
  end
end