class CreateTournamentDays < ActiveRecord::Migration
  def self.up
    create_table :tournament_days do |t|
      t.integer :tournament_id
      t.date :day
      t.integer :max_inscriptions

      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_days
  end
end
