class AddMaxParticipantsToSeries < ActiveRecord::Migration
  def change
    add_column :series, :max_participants, :int
  end
end
