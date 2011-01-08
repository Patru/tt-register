class AddTournamentDayToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :tournament_day_id, :integer, :default => 1
  end

  def self.down
    remove_column :series, :tournament_day_id, :integer
  end
end
