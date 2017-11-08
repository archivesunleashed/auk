# frozen_string_literal: true

# Application mailer methods.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
