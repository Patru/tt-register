class RenameColumnInKeepInformed < ActiveRecord::Migration
  def change
    rename_column :keep_informeds, :unlicensened, :unlicensed
  end
end
