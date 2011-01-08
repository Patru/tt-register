class WaitingListSeries < ActiveRecord::Base
  belongs_to :waiting_list_entry
  belongs_to :series
end
