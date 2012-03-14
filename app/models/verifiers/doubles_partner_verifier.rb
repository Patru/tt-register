module Verifiers::DoublesPartnerVerifier
  def verify_partners(inscription_player, play_ser)
    if inscription_player.player_id == play_ser.partner_id
      inscription_player.errors.add_to_base("#{inscription_player.player.long_name} " +
                                                    " darf nicht mit sich selber Doppel spielen")
      return false
    elsif not may_be_played_by?(play_ser.partner)
      inscription_player.errors.add_to_base("#{play_ser.partner.long_name} " +
                                                    "darf in der Serie #{play_ser.series.long_name} nicht teilnehmen!")
      return false
    else
      return partner_not_in_series_otherwise?(play_ser, inscription_player)
    end
  end

  def partner_not_in_series_otherwise?(play_ser, inscription_player)
    as_player = PlaySeries.first(:joins => :inscription_player,
                    :conditions => {:inscription_players => {:player_id => play_ser.partner_id},
                                    :series_id => play_ser.series_id})
    if as_player.nil?
      inscription_player.notices << "Dein Partner #{play_ser.partner.long_name} ist noch nicht angemeldet, bitte melde in an oder informiere ihn."
    elsif as_player.partner_id == nil
      inscription_player.notices << "Dein Partner #{play_ser.partner.long_name} ist im " +
              "#{play_ser.series.long_name} bisher offen angemeldet, bitte informiere ihn."
    elsif as_player.partner_id !=  inscription_player.player_id
      inscription_player.errors.add_to_base("#{play_ser.partner.long_name}" +
              " spielt in der Serie #{play_ser.series.long_name}" +
              " schon mit #{as_player.partner.long_name}, bitte wähle einen anderen Partner")
      return false
    end

    as_partner = PlaySeries.first(:conditions => {:partner_id => play_ser.partner_id, :series_id => play_ser.series_id})
    if not as_partner.nil? and as_partner.player.id != inscription_player.player_id
      inscription_player.errors.add_to_base("#{play_ser.partner.long_name}" +
                    " spielt in der Serie #{play_ser.series.long_name}" +
                    " schon mit #{as_partner.player.long_name}, bitte wähle einen anderen Partner")
      return false
    end
    return true
  end
end
