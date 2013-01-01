# encoding: UTF-8

class Confirmation < ActionMailer::Base
  default charset: 'UTF-8'

  def confirmation(inscription, host)
     recipients inscription.email
     from       inscription.tournament.sender_email
     bcc        inscription.tournament.bcc_email
     subject    "Bestätigung der Einschreibung"
     @inscription = inscription
     @host = host
  end

  def inscription_player_confirmation(inscription_player)
    inscription=inscription_player.inscription
    recipients inscription.email
    from       inscription.tournament.sender_email
    bcc        inscription.tournament.bcc_email
    subject    "Bestätigung der Anmeldung von #{inscription_player.player.long_name}"
    @inscription_player = inscription_player
  end

  def inscription_player_update(inscription_player)
    inscription=inscription_player.inscription
    recipients inscription.email
    from       inscription.tournament.sender_email
    bcc        inscription.tournament.bcc_email
    subject    "Änderung der Anmeldung von #{inscription_player.player.long_name}"
    @inscription_player = inscription_player
  end

  def deregistration(inscription_player)
    @inscription_player = inscription_player
    inscription=inscription_player.inscription
    recipients inscription.email
    from       inscription.tournament.sender_email
    bcc        inscription.tournament.bcc_email
    subject    "Abmeldung von #{inscription_player.player.long_name}"
  end

  def resend(inscription, host)
    @inscription = inscription
    @host = host
    recipients inscription.email
    from       inscription.tournament.sender_email
    bcc        inscription.tournament.bcc_email
    subject    "Erneute Zustellung des Login-Links"
  end

  def mail_team(email, recipient)
     recipients recipient
     from       email.from
     subject    email.subject
     @body = email.text
  end

  def admin_confirmation(new_admin, admin, host)
     recipients new_admin.email
     from       admin ? admin.email : "zueri-open@ttvz.ch"
     subject    "Anmeldelink für Administrator"
     @new_admin = new_admin
     @admin = admin
     @host = host
  end
end
