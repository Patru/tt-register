class AddRankToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :rank, :integer
    add_column :players, :woman_rank, :integer
  end

  def self.down
    remove_column :players, :rank
    remove_column :players, :woman_rank
  end
end
