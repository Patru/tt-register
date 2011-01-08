class Email
  attr_accessor :from, :subject, :text, :errors
  def initialize(from = "", subject="", text="")
    self.from=from
    self.subject = subject
    self.text = text
    self.errors = ActiveRecord::Errors.new(nil)
  end
end
