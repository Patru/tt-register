class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer :licence
      t.string :name
      t.string :first_name
      t.string :club
      t.integer :ranking
      t.integer :woman_ranking

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
