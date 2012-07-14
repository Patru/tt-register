class Email
  attr_accessor :from, :subject, :text, :errors
  PATTERN=/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def initialize(from = "", subject="", text="")
    self.from=from
    self.subject = subject
    self.text = text
    self.errors = ActiveRecord::Errors.new(nil)
  end

  def valid?
    if from.blank?
      errors.add_to_base "Wir benötigen deine Email-Adresse um dich kontaktieren zu können!"
    elsif not from =~ PATTERN
      errors.add_to_base "Das Format deiner Email-Adresse ist nicht korrekt"
    end
    if text.blank?
      errors.add_to_base "Der Text deiner Meldung ist leer"
    end
    errors.size == 0
  end
end
