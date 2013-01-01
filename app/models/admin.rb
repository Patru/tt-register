# encoding: UTF-8

class Admin < ActiveRecord::Base
  belongs_to :tournament
  attr_accessor :password
  validates_presence_of :name, :password

  def hash_password(salt=nil)
    if self.salt.nil? then
      self.salt = salt
    end
    self.salt = rand_str(9) if self.salt.nil?
    self.hashed_password = Digest::SHA2.hexdigest(self.salt + password)
  end

  def matches?(other)
    other.hash_password(self.salt)
    return self.hashed_password.eql?(other.hashed_password)
  end
end
