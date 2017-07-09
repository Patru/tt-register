class AddSaltHashToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :salt, :string
    add_column :tournaments, :hashed_api_key, :string
  end
end
