class AddSaltToInscription < ActiveRecord::Migration
  def self.up
    add_column :inscriptions, :salt, :string
    add_column :inscriptions, :secret, :string
  end

  def self.down
    remove_column :inscriptions, :salt
    remove_column :inscriptions, :secret
  end
end
