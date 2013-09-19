class AddLastInscriptionTimeToTournamentDay < ActiveRecord::Migration
  def change
    add_column :tournament_days, :last_inscription_time, :datetime
  end
end
