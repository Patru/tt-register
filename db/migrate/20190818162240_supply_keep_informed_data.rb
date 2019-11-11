class SupplyKeepInformedData < ActiveRecord::Migration
  def up
    KeepInformed.all.each do |keepInf|
      ins=Inscription.where(tournament_id: keepInf.tournament_id, email:keepInf.email).first
      unless ins.nil?
        keepInf.licence = ins.licence
        keepInf.salutation = "#{ins.anrede} #{ins.name}"
        unless ins.language.nil?
          keepInf.language = ins.language
        else
          keepInf.language= I18n.locale
        end
        keepInf.save
      end
    end
  end

  def down
  end
end
