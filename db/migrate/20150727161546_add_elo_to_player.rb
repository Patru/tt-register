class AddEloToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :elo, :integer
  end
end
