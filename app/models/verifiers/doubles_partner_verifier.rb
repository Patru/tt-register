module Verifiers::DoublesPartnerVerifier
  def verify_partners(inscription_player, play_ser)
    if inscription_player.player_id == play_ser.partner_id
      inscription_player.errors.add_to_base("#{inscription_player.player.long_name} " +
                                                    " darf nicht mit sich selber Doppel spielen")
    elsif not may_be_played_by?(play_ser.partner)
      inscription_player.errors.add_to_base("#{play_ser.partner.long_name} " +
                                                    "darf in der Serie #{play_ser.series.long_name} nicht teilnehmen!")
    end
  end
end
