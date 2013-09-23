class AddOnlyShowPlayableSeriesToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :only_show_playable_series, :boolean
  end
end
