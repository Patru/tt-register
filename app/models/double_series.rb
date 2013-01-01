# encoding: UTF-8

class DoubleSeries < Series
  include Verifiers::DoublesPartnerVerifier

  def playing
    full={}
    super.each do |play_ser|
      unless play_ser.partner.nil?
        full[play_ser.player] = play_ser if full[play_ser.player].nil?
        full[play_ser.partner] = play_ser if full[play_ser.partner].nil?
      end
    end
    play_sers=Set.new
    full.values.each do |play_ser|
      play_sers << play_ser
    end
    play_sers.to_a
  end

  def open
    pl_list = PlayerList.new("Offen gemeldet")
    pl_list.play_sers=play_series.select{|pls| pls.partner.nil?}.sort
    unless pl_list.play_sers.empty?
      [pl_list]
    else
      []
    end
  end
end