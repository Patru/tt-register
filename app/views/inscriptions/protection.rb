# encoding: UTF-8

class Views::Inscriptions::Protection < Views::Inscriptions::Inscription
#  needs :tournaments, :inscription
  def page_title
    'Datenschutzbestimmungen'
  end

  def sw_content
    p do
      text "Der Schutz deiner persönlichen Daten ist uns wichtig, deshalb möchten wir auf die herrschende Gesetzeslage aufmerksam machen. Das "
      link_to "Bundesgesetz über den Datenschutz", "http://www.admin.ch/ch/d/sr/2/235.1.de.pdf"
      text " besagt im Artikel 4.3, dass Personendaten nur zu dem Zweck bearbeitet werden dürfen "
      text "welcher bei der Erhebung angegeben wurde. "
    end
    p do
      text "Mit diesem Programm werden Daten gesammelt um ein Tischtennisturnier zu organisieren. "
      text "Dazu ist es erforderlich, allen angemeldeten Person die ausgewählten Serien zuordnen zu können. "
      text "Darüber hinaus speichern wir nur so wenige Personendaten wie möglich, nämlich"
    end
    ul do
      li "Eine E-Mail Adresse zu jeder erstellten Einschreibungen (um die Verantwortlichen kontaktieren zu können)"
      li "Alle Emails die von diesem Programm verschickt werden (zur Nachprüfung bei Störungen)"
    end
    p do
      text "Deine E-Mail Adresse wird auf der Seite nicht publiziert, sie bleibt lediglich für dich und das Turnier-Team sichtbar. "
      text "Die E-Mail Adresse wird nur zur Organisation des Turniers verwendet und nicht weiter gegeben, es besteht also keine Spam-Gefahr. "
      text "Die Stammdaten aller Tischtennisspieler der Schweiz stammen aus der "
      link_to "Zentralregistratur", "http://www.swisstabletennis.ch/component/option,com_wrapper/Itemid,200/lang,de/"
      text " von "
      link_to "STT", "http://www.sttv.ch"
      text " sie gelten deshalb als öffentlich. Auf dieser Seite sind sie nur für die Erfasser einer Einschreibung uneingeschränkt sichtbar. "
      text "Öffentlich zugänglich ist lediglich die Liste der Teilnehmer aller Serien (über die Links auf der rechten Seite)."
    end
  end
end