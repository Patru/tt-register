class AddLicenceToKeepInformeds < ActiveRecord::Migration
  def change
    add_column :keep_informeds, :licence, :integer              # for new invitations if applicable
    add_column :keep_informeds, :salutation, :string
    add_column :keep_informeds, :verification_token, :string    # to verify the address later
    add_column :keep_informeds, :language, :string              # to send e-mails in the correct language
  end
end
