class AddFaviconToTournament < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :favicon, :text
  end

  def self.down
    remove_column :tournaments, :favicon
  end
end
