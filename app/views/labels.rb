require File.dirname(__FILE__) + '/columns.rb'
class Views::Labels
  def self.label(symbol)
    if @@labels.has_key?(symbol)
      @@labels[symbol]+":"
    else
      Views::Columns.header(symbol)+":"
    end
  end
  @@labels = {
    :woman_ranking => "Damenklassierung",
    :max_ranking => "Klassierung bis",
    :max_inscriptions => "Einschreibungen maximal",
    :logo => "Logo",
    :stylesheet => "Stylesheet",
    :series_per_day => "Serien pro Tag",
    :password => "Passwort",
    :token => "Token",
    :from => "Von",
    :subject => "Betreff",
    :text => "Text",
    :rank => "Ranking",
    :woman_rank => "Damen-Ranking",
    :disp_ranking => "Klassierung",
    :disp_woman_ranking => "Damenklassierung",
    :use_rank => "Ranking bis",
    :type => "Typ",
    :max_single_series => "Anzahl Einzelserien",
    :max_double_series => "Anzahl Doppelserien",
    :max_age_series => "Anzahl Altersserien",
    :layout_parser => "Layout/Parsing für Serien",
    :favicon => "Icon für Link"
  }
end