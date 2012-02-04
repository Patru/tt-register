class AddSeriesTypeToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :type, :string
  end

  def self.down
    remove_column :series, :type
  end
end
