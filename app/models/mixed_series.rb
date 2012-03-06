class MixedSeries < DoubleSeries
  include Verifiers::DoublesPartnerVerifier

  def verify_partners(inscription_player, play_ser)
    super(inscription_player, play_ser)
    if inscription_player.player.male? and play_ser.partner.male?
      inscription_player.errors.add_to_base "#{inscription_player.player.long_name} " +
              " braucht eine weibliche Partnerin für das #{play_ser.series.long_name}"
    elsif inscription_player.player.female? and play_ser.partner.female?
      inscription_player.errors.add_to_base "#{inscription_player.player.long_name} " +
              " braucht einen männlichen Partner für das #{play_ser.series.long_name}"
    end
  end

  def ranking_of(player)
    if player.male?
      player.ranking
    else
      player.woman_ranking
    end
  end

  def open
    open_pls = super
    return open_pls if open_pls.empty?
    pls=open_pls[0]
    res=[]
    females=pls.play_sers.select{|pl_ser| pl_ser.player.female?}.sort
    res << PlayerList.new("Offen gemeldete Damen", females) unless females.empty?
    males=pls.play_sers.select{|pl_ser| pl_ser.player.male?}.sort
    res << PlayerList.new("Offen gemeldete Herren", males) unless males.empty?
  end
end