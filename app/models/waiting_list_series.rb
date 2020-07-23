# encoding: UTF-8

class WaitingListSeries < ActiveRecord::Base
  belongs_to :waiting_list_entry
  belongs_to :series

  def to_transfer_data
    WaitingListTransfer.new(self)
  end
end

class WaitingListTransfer
  attr_accessor :licence, :series, :partner_licence, :created_at

  def initialize(waiting_list_series)
    @licence = waiting_list_series.waiting_list_entry.inscription_player.player.licence
    @series = waiting_list_series.series.series_name
    @partner_licence=nil
    @created_at = waiting_list_series.created_at
  end
end