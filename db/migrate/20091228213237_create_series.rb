class CreateSeries < ActiveRecord::Migration
  def self.up
    create_table :series do |t|
      t.string :series_name
      t.string :long_name
      t.time :start_time
      t.integer :min_ranking
      t.integer :max_ranking
      t.string :category
      t.string :sex

      t.timestamps
    end
  end

  def self.down
    drop_table :series
  end
end
