class AddRemarkToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :remark_de, :string
    add_column :tournaments, :remark_fr, :string
    add_column :tournaments, :remark_en, :string
  end
end
