class Confirmation < ActionMailer::Base
  def confirmation(inscription, host)
     recipients inscription.email
     from       "zueri-open@ttvz.ch"
     bcc        "zueri.open@soft-werker.ch"
     subject    "Bestätigung der Einschreibung"
     body       :inscription => inscription, :host => host
  end

  def inscription_player_confirmation(inscription_player)
     recipients inscription_player.inscription.email
     from       "zueri-open@ttvz.ch"
     bcc        "zueri.open@soft-werker.ch"
     subject    "Bestätigung der Anmeldung von #{inscription_player.player.long_name}"
     body       :inscription_player => inscription_player
  end

  def deregistration(inscription_player)
     recipients inscription_player.inscription.email
     from       "zueri-open@ttvz.ch"
     bcc        "zueri.open@soft-werker.ch"
     subject    "Abmeldung von #{inscription_player.player.long_name}"
     body       :inscription_player => inscription_player
  end

  def resend(inscription, host)
     recipients inscription.email
     from       "zueri-open@ttvz.ch"
     bcc        "zueri.open@soft-werker.ch"
     subject    "Erneute Zustellung des Login-Links"
     body       :inscription => inscription, :host => host
  end

  def mail_team(email)
     recipients "zueri-open@ttvz.ch"
     from       email.from
     subject    email.subject
     body       :body => email.text
  end

  def admin_confirmation(new_admin, admin, host)
     recipients new_admin.email
     from       admin ? admin.email : "zueri-open@ttvz.ch"
     subject    "Anmeldelink für Administrator"
     body       :new_admin => new_admin, :admin => admin, :host => host
  end

end
