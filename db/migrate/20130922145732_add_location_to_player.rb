class AddLocationToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :rv, :string
    add_column :players, :canton, :string
  end
end
