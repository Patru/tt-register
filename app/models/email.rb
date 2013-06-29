# encoding: UTF-8

class Email
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  attr_accessor :from, :subject, :text, :errors
  PATTERN=/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def initialize(from = "", subject="", text="")
    self.from=from
    self.subject = subject
    self.text = text
    self.errors = ActiveModel::Errors.new(nil)
  end

  def valid?
    if from.blank?
      errors.add :base, "Wir benötigen deine E-Mail Adresse um dich kontaktieren zu können!"
      # maybe this needs to go to :base if the form does not work otherwise
    elsif not from =~ PATTERN
      errors.add :base, "Das Format deiner E-Mail Adresse ist nicht korrekt"
    end
    if text.blank?
      errors.add :base, "Der Text deiner Meldung ist leer"
    end
    errors.size == 0
  end

  def persisted?
    false
  end
end
