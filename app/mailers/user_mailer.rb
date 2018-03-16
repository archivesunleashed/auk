# frozen_string_literal: true

# Methods for User Mailer
class UserMailer < ApplicationMailer
  def notify_collection_analyzed(user_id, collection_id)
    attachments.inline['white-logo.png'] =
      File.read('app/assets/images/white-logo.png')
    @user = User.find(user_id)
    @collection = Collection.find(collection_id)
    mail(to: @user.email, subject: @collection.title +
         ' has been analyzed!') do |format|
      format.text
      format.html
    end
  end

  def notify_collection_downloaded(user_id, collection_id)
    attachments.inline['white-logo.png'] =
      File.read('app/assets/images/white-logo.png')
    @user = User.find(user_id)
    @collection = Collection.find(collection_id)
    mail(to: @user.email, subject: @collection.title +
         ' has been downloaded!') do |format|
      format.text
      format.html
    end
  end

  def notify_collection_setup(user_id)
    attachments.inline['white-logo.png'] =
      File.read('app/assets/images/white-logo.png')
    @user = User.find(user_id)
    mail(to: @user.email,
         subject: 'Your collections have been synced!') do |format|
      format.text
      format.html
    end
  end
end
