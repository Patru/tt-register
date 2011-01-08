class CreateWaitingListSeries < ActiveRecord::Migration
  def self.up
    create_table :waiting_list_series do |t|
      t.integer :waiting_list_entry_id
      t.integer :series_id

      t.timestamps
    end
  end

  def self.down
    drop_table :waiting_list_series
  end
end
