# encoding: UTF-8

class TransferInscription < ActionMailer::Base
  def transfer_inscription(inscription, inscription_player, original, host)
    @inscription = inscription
    @inscription_player = inscription_player
    @original = original
    @host = host
    mail(to:      inscription.email,
         from:    inscription.tournament.sender_email,
         bcc:     inscription.tournament.bcc_email,
         subject: I18n.t('mailer.transfer_inscription.subject'))
  end
end
