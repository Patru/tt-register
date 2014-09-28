class AddThanksForInterestLocalizedToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :thanks_for_interest_en, :string
    add_column :tournaments, :thanks_for_interest_de, :string
    add_column :tournaments, :thanks_for_interest_fr, :string
  end
end
