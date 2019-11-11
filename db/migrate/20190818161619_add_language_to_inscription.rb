class AddLanguageToInscription < ActiveRecord::Migration
  def change
    add_column :inscriptions, :language, :string
  end
end
