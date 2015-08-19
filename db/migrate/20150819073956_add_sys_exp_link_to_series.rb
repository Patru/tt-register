class AddSysExpLinkToSeries < ActiveRecord::Migration
  def change
    add_column :series, :sys_exp_link_de, :string
    add_column :series, :sys_exp_link_fr, :string
    add_column :series, :sys_exp_link_en, :string
  end
end
