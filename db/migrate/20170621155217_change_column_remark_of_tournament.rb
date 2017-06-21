class ChangeColumnRemarkOfTournament < ActiveRecord::Migration
  def up
    change_column :tournaments, :remark_de, :string, :limit => 3500
    change_column :tournaments, :remark_fr, :string, :limit => 3500
    change_column :tournaments, :remark_en, :string, :limit => 3500
  end

  def down
    change_column :tournaments, :remark_de, :string, :limit => 255
    change_column :tournaments, :remark_fr, :string, :limit => 255
    change_column :tournaments, :remark_en, :string, :limit => 255
  end
end
