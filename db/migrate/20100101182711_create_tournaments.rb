class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.string :tour_id
      t.string :name
      t.string :date
      t.string :info_link
      t.string :organiser

      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
