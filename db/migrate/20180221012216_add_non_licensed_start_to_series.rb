class AddNonLicensedStartToSeries < ActiveRecord::Migration
  def change
    add_column :series, :non_licensed_start, :integer
  end
end
