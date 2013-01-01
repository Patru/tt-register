# encoding: UTF-8

class PlayerList
  attr_accessor :title, :play_sers

  def initialize(aTitle, list=[])
    @title=aTitle
    @play_sers = list
  end
end