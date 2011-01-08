class CreateWaitingListEntries < ActiveRecord::Migration
  def self.up
    create_table :waiting_list_entries do |t|
      t.integer :tournament_day_id
      t.integer :inscription_player_id

      t.timestamps
    end
  end

  def self.down
    drop_table :waiting_list_entries
  end
end
