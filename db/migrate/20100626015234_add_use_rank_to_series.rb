class AddUseRankToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :use_rank, :integer
  end

  def self.down
    remove_column :series, :use_rank
  end
end
