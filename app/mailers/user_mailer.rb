# frozen_string_literal: true

# Methods for User Mailer
class UserMailer < ApplicationMailer
  def notify_collection_analyzed(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Collection is analyzed') do |format|
      format.text
      format.html
    end
  end

  def notify_collection_downloaded(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Collection is downloaded') do |format|
      format.text
      format.html
    end
  end

  def notify_collection_setup(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Collections are setup') do |format|
      format.text
      format.html
    end
  end
end
