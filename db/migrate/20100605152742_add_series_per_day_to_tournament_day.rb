class AddSeriesPerDayToTournamentDay < ActiveRecord::Migration
  def self.up
    add_column :tournament_days, :series_per_day, :integer
  end

  def self.down
    remove_column :tournament_days, :series_per_day
  end
end
