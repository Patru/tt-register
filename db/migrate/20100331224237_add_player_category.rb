class AddPlayerCategory < ActiveRecord::Migration
  def self.up
    add_column :players, :category,  :string,   :default => "-"    
 end

  def self.down
    remove_column :players, :category
  end
end
