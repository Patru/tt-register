class Views::Inscriptions::New < Views::Inscriptions::Inscription
#  needs :tournaments, :inscription
  def page_title
    'Neue Einschreibung'
  end
  
  def page_menu
  end
  
  def sw_content
    p "Lieber Tischtennisfreund"
    p "Vielen Dank für dein Interesse am #{tournament.name}. Hier bist du richtig um dich oder andere Spieler fürs Turnier anzumelden."
    p do
      text "Um bei Problemen mit einer Anmeldung Rückfragen stellen zu können, möchten wir zu allen Einschreibungen eine Email-Adresse "
      text "speichern. Bitte erstelle deshalb im untenstehenden Formular eine Einschreibung. Die Eingabe der Lizenznummer ist am "
      text "einfachsten, dann findet das Programm deinen Namen selber (falls du keinen Spitznamen auswählen möchtest). "
      text "Du kannst dich aber auch nur mit Namen und Email-Adresse anmelden. "
    end
    p do
      text "Nachdem die Einschreibung gespeichert ist, stellen wir dir eine Email mit einem Bestätigungs-Link zu, der auch als Login dient. "
      text "Bitte bewahre die Email auf, denn damit kannst du deine Anmeldungen leicht abändern und verwalten. Da die Einschreibung nur "
      text "bis zum Turnier gültig ist, kannst du die Email auch an andere weiter geben, wenn du z.B. in die Ferien gehst. "
      link_to "Natürlich stellen wir dir auch einen neuen login-Link zu", resend_link_path
      text " falls du ihn versehentlich gelöscht hast, der alte Link ist danach nicht mehr gültig. "
    end
    p do
      text "Darüber hinaus halten wir dich per Email über alle Veränderungen an deiner Einschreibung auf dem laufenden. "
      text "Wenn also Spieler an- oder abgemeldet werden, so verschicken wir dafür jedes mal eine Email. "
      text "Normalerweise hast du diese Anpassungen zwar selber vorgenommen, "
      text "im Zweifelsfall kannst du so aber auch Missbräuche rasch erkennen."
    end
    p do
      text "Wie alle Betreiber von Internet-Seiten müssen auch wir uns Gedanken über den "
      link_to "Datenschutz", protection_path
      text " machen. "
      text "Falls du weitere Fragen oder Anregungen hast, so kannst du dem "
      link_to "Turnier-Team eine Email schicken", email_form_path
      text "."
    end
    h2 "Neue Einschreibung erstellen"
    inscription_form "Einschreibung erstellen und Email-Adresse bestätigen"
  end
end