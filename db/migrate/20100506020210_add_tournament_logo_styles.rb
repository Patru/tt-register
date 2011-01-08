class AddTournamentLogoStyles < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :logo,  :string
    add_column :tournaments, :stylesheet,  :string
  end

  def self.down
    remove_column :tournaments, :logo
    remove_column :tournaments, :stylesheet
  end
end
