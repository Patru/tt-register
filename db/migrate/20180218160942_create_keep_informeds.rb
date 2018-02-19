class CreateKeepInformeds < ActiveRecord::Migration
  def change
    create_table :keep_informeds do |t|
      t.integer :tournament_id
      t.string :email
      t.boolean :create_inscription
      t.boolean :unlicensened

      t.timestamps
    end
  end
end
