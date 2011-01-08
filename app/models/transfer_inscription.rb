class TransferInscription < ActionMailer::Base
  def transfer_inscription(inscription, inscription_player, original)
     recipients inscription.email
     from       "turnier@ysz.ch"
     subject    "Übertragung deiner Einschreibung"
     body       :inscription => inscription, :inscription_player => inscription_player, :original => original
  end
end
