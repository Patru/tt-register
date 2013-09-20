# encoding: UTF-8

class PlayerSeries
  attr_reader :player
  def initialize(all)
    @all=all
    @series = {}
  end

  def <<(pl_ser)
    if @player.nil?
      @player=pl_ser.player
    end

    if MixedSeries === pl_ser.series
      @mixed = pl_ser
    elsif DoubleSeries === pl_ser.series
      @double = pl_ser
    end

    @series[pl_ser.series]=pl_ser
    self
  end

  def line
    attrs=[@player.club, @player.licence, @player.name, @player.first_name,
        @player.category, @player.ranking, @player.woman_ranking, nil]
    attrs.concat xs
    attrs.concat doubles_partners
  end

  def xs
    as_xs = []
    @all.each do |ser|
      if @series.has_key? ser
        as_xs << "x"
      else
        as_xs << nil
      end
    end
    as_xs
  end


  def doubles_partners
    partners=[]
    if @double
      if @double.partner
        partners.concat [@double.partner.long_name, @double.partner.licence]
      else
        partners.concat ["offen", nil]
      end
    else
      partners.concat [nil, nil]
    end
    if @mixed
      if @mixed.partner
        partners.concat [@mixed.partner.long_name, @mixed.partner.licence]
      else
        partners.concat ["offen", nil]
      end
    else
      partners.concat [nil, nil]
    end
    partners
  end
end