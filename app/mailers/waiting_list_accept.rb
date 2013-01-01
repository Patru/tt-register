# encoding: UTF-8

class WaitingListAccept < ActionMailer::Base
  def accept(waiting_list_entry)
    inscription=waiting_list_entry.inscription_player.inscription
    recipients inscription.email
    from       inscription.tournament.sender_email
    bcc        inscription.tournament.bcc_email
    subject    "Anmeldung durch Abbau der Warteliste für das #{waiting_list_entry.inscription_player.inscription.tournament.name}"
    @inscription_player = waiting_list_entry.inscription_player
    @tournament_day = waiting_list_entry.tournament_day
  end
end
