class Views::Columns
  def self.header(symbol)
    if @@headers.has_key?(symbol)
      @@headers[symbol]
    else
      "@"+symbol.to_s
    end
  end
  @@headers = {
    :name => "Name",
    :first_name => "Vorname",
    :nickname => "Login",
    :email => "E-mail",
    :date_of_birth => "Geburtsdatum",
    :club => "Club",
    :licence => "Lizenz",
    :ranking => "Klassierung",
    :woman_ranking => "Damenklass.",
    :series_name => "Kürzel",
    :long_name => "Name",
    :start_time => "Start",
    :start_time_text => "Start",
    :min_ranking => "Klassierung von",
    :max_ranking => "bis",
    :category => "Alterskategorie",
    :sex => "Geschlecht",
    :tour_id => "Turnier-ID",
    :date => "Datum",
    :organiser => "Organisator",
    :info_link => "Link für weitere Infos",
    :day => "Tag",
    :max_inscriptions => "Max. Einschreibungen",
    :tournament_id => "Turnier",
    :tournament => "Turnier",
    :tournament_day_id => "Turniertag",
    :series => "Serien",
    :inscribed_for => "Eingeschrieben für"
  }
end