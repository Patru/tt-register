class AddSenderFacebookToTournament < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :sender_email, :string
    add_column :tournaments, :bcc_email, :string
    add_column :tournaments, :facebook_link, :string
  end

  def self.down
    remove_column :tournaments, :facebook_link
    remove_column :tournaments, :bcc_email
    remove_column :tournaments, :sender_email
  end
end
