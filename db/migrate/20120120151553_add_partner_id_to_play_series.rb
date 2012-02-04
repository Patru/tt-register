class AddPartnerIdToPlaySeries < ActiveRecord::Migration
  def self.up
    add_column :play_series, :partner_id, :integer
  end

  def self.down
    remove_column :play_series, :partner_id
  end
end
