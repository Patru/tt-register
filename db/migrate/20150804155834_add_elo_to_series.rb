class AddEloToSeries < ActiveRecord::Migration
  def change
    add_column :series, :min_elo, :integer
    add_column :series, :max_elo, :integer
    add_column :series, :slack_elo, :integer
    add_column :series, :slack_days, :integer
  end
end
