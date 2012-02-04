class AddMaxSingleDoubleAgeToTournamentDay < ActiveRecord::Migration
  def self.up
    add_column :tournament_days, :max_single_series, :integer
    add_column :tournament_days, :max_double_series, :integer
    add_column :tournament_days, :max_age_series, :integer
  end

  def self.down
    remove_column :tournament_days, :max_age_series
    remove_column :tournament_days, :max_double_series
    remove_column :tournament_days, :max_single_series
  end
end
