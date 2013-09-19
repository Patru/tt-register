class AddLastInscriptionTimeToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :last_inscription_time, :datetime
  end
end
