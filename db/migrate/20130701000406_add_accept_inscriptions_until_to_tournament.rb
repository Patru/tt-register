class AddAcceptInscriptionsUntilToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :accept_inscriptions_until, :datetime
  end
end
