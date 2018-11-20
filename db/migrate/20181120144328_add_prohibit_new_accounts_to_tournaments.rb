class AddProhibitNewAccountsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :prohibit_new_accounts, :boolean
  end
end
