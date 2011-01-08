class CreateInscriptions < ActiveRecord::Migration
  def self.up
    create_table :inscriptions do |t|
      t.integer :tournament_id
      t.integer :licence
      t.string :name
      t.string :email
      t.string :token

      t.timestamps
    end
  end

  def self.down
    drop_table :inscriptions
  end
end
