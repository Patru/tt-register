# encoding: UTF-8

class Confirmation < ActionMailer::Base
  default charset: 'UTF-8'

  def confirmation(inscription, host)
    @inscription = inscription
    @host = host
    mail(to:      inscription.email,
         from:    inscription.tournament.sender_email,
         bcc:     inscription.tournament.bcc_email,
         subject: I18n.t('mailer.confirmation.subject'))
  end

  def inscription_player_confirmation(inscription_player)
    inscription=inscription_player.inscription
    @inscription_player = inscription_player
    mail(to:     inscription.email,
        from:    inscription.tournament.sender_email,
        bcc:     inscription.tournament.bcc_email,
        subject: I18n.t('mailer.inscription_player_confirmation.subject', player_name:inscription_player.player.long_name))
  end

  def inscription_player_update(inscription_player)
    inscription=inscription_player.inscription
    @inscription_player = inscription_player
    mail(to:     inscription.email,
        from:    inscription.tournament.sender_email,
        bcc:     inscription.tournament.bcc_email,
        subject: I18n.t('mailer.inscription_changed.subject', player_name:inscription_player.player.long_name))
  end

  def deregistration(inscription_player)
    @inscription_player = inscription_player
    inscription=inscription_player.inscription
    mail(to:      inscription.email,
         from:    inscription.tournament.sender_email,
         bcc:     inscription.tournament.bcc_email,
         subject: I18n.t('mailer.deregistration.subject', player_name: inscription_player.player.long_name))
  end

  def resend(inscription, host)
    @inscription = inscription
    @host = host
    mail(to:      inscription.email,
         from:    inscription.tournament.sender_email,
         bcc:     inscription.tournament.bcc_email,
         subject: I18n.t('mailer.resend_login.subject'))
  end

  def mail_team(email, recipient)
    @body = email.text
    mail(to: recipient,
         from: email.from,
         subject: email.subject)
  end

  def admin_confirmation(new_admin, admin, host)
    @new_admin = new_admin
    @admin = admin
    @host = host
    mail(to: new_admin.email,
         from: admin ? admin.email : "info@soft-werker.ch",
         subject: "Anmeldelink für Administrator")
  end
end
