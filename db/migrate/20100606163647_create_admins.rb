class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :name
      t.string :salt
      t.string :email
      t.string :hashed_password
      t.string :token
      t.integer :tournament_id

      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
