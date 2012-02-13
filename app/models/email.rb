class Email
  attr_accessor :from, :subject, :text, :errors

  def initialize(from = "", subject="", text="")
    self.from=from
    self.subject = subject
    self.text = text
    self.errors = ActiveRecord::Errors.new(nil)
  end

  def valid?
    if from.blank?
      errors.add_to_base "Wir benötigen deine Email-Adresse um dich kontaktieren zu können!"
      return false
    end
    return true
  end
end
