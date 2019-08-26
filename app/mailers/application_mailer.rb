# frozen_string_literal: true

# Application mailer methods.
class ApplicationMailer < ActionMailer::Base
  default from: 'The Archives Unleashed Cloud <' + ENV['EMAIL_USERNAME'] + '>'
  layout 'mailer'
end
