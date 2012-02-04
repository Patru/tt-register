class AddLayoutParserToTournament < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :layout_parser, :string
  end

  def self.down
    remove_column :tournaments, :layout_parser
  end
end
