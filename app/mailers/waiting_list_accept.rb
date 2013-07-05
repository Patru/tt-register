# encoding: UTF-8

class WaitingListAccept < ActionMailer::Base
  def accept(waiting_list_entry)
    inscription=waiting_list_entry.inscription_player.inscription
    @inscription_player = waiting_list_entry.inscription_player
    @tournament_day = waiting_list_entry.tournament_day
    mail(to:     inscription.email,
        from:    inscription.tournament.sender_email,
        bcc:     inscription.tournament.bcc_email,
        subject: t('mailer.waiting_list_accept.subject',
                   tournment: waiting_list_entry.inscription_player.inscription.tournament.name))
  end
end
