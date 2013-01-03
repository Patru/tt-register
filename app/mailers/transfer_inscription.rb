# encoding: UTF-8

class TransferInscription < ActionMailer::Base
  def transfer_inscription(inscription, inscription_player, original)
    @inscription = inscription
    @inscription_player = inscription_player
    @original = original
    mail(to:      inscription.email,
         from:    inscription.tournament.sender_email,
         bcc:     inscription.tournament.bcc_email,
         subject: "Übertragung deiner Einschreibung")
  end
end
