class CreateQuarks < ActiveRecord::Migration
  def self.up
    create_table :quarks do |t|
      t.string :name
      t.integer :age
      t.decimal :price

      t.timestamps
    end
  end

  def self.down
    drop_table :quarks
  end
end
