class CreateInscriptionPlayers < ActiveRecord::Migration
  def self.up
    create_table :inscription_players do |t|
      t.integer :inscription_id
      t.integer :player_id

      t.timestamps
    end
  end

  def self.down
    drop_table :inscription_players
  end
end
