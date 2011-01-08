class WaitingListAccept < ActionMailer::Base
  def accept(waiting_list_entry)
     recipients waiting_list_entry.inscription_player.inscription.email
     from       "turniere@ysz.ch"
     bcc        "turnier-archiv@ysz.ch"
     subject    "Anmeldung durch Abbau der Warteliste für das #{waiting_list_entry.inscription_player.inscription.tournament.name}"
     body       :inscription_player => waiting_list_entry.inscription_player, :tournament_day => waiting_list_entry.tournament_day
  end
end
