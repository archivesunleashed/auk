# frozen_string_literal: true

# Application mailer methods.
class ApplicationMailer < ActionMailer::Base
  default from: 'hist-arc@uwaterloo.ca'
  layout 'mailer'
end
