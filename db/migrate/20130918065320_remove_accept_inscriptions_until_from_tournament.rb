class RemoveAcceptInscriptionsUntilFromTournament < ActiveRecord::Migration
  def up
    remove_column :tournaments, :accept_inscriptions_until
  end

  def down
    add_column :tournaments, :accept_inscriptions_until, :datetime
  end
end
