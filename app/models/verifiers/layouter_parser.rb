# encoding: UTF-8

class Verifiers::LayouterParser
  def self.all_subclasses
    ObjectSpace.each_object(self.singleton_class).select do |cl| cl.respond_to? :display_name end
  end
end