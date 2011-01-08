class CreatePlaySeries < ActiveRecord::Migration
  def self.up
    create_table :play_series do |t|
      t.integer :inscription_player_id
      t.integer :series_id

      t.timestamps
    end
  end

  def self.down
    drop_table :play_series
  end
end
