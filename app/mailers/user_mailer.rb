# frozen_string_literal: true

# Methods for User Mailer
class UserMailer < ApplicationMailer
  def notify_collection_analyzed(user_id, collection_id)
    attachments.inline['AUK-Logo-full.png'] =
      File.read('app/assets/images/AUK-Logo-full.png')
    @user = User.find(user_id)
    @collection = Collection.find(collection_id)
    mail(to: @user.email, subject: @collection.title +
         ' has been analyzed!') do |format|
      format.text
      format.html
    end
  end

  def notify_collection_downloaded(user_id, collection_id)
    attachments.inline['AUK-Logo-full.png'] =
      File.read('app/assets/images/AUK-Logo-full.png')
    @user = User.find(user_id)
    @collection = Collection.find(collection_id)
    mail(to: @user.email, subject: @collection.title +
         ' has been downloaded!') do |format|
      format.text
      format.html
    end
  end

  def notify_collection_setup(user_id)
    attachments.inline['AUK-Logo-full.png'] =
      File.read('app/assets/images/AUK-Logo-full.png')
    @user = User.find(user_id)
    mail(to: @user.email,
         subject: 'Your collections have been synced!') do |format|
      format.text
      format.html
    end
  end

  def notify_collection_failed(user_id, collection_id)
    attachments.inline['AUK-Logo-full.png'] =
      File.read('app/assets/images/AUK-Logo-full.png')
    @user = User.find(user_id)
    @collection = Collection.find(collection_id)
    mail(to: @user.email,
         cc: 'ruestn+auk@gmail.com',
         subject: 'We had a problem analyzing ' + @collection.title) do |format|
      format.text
      format.html
    end
  end

  def notify_download_failed(user_id, collection_id)
    attachments.inline['AUK-Logo-full.png'] =
      File.read('app/assets/images/AUK-Logo-full.png')
    @user = User.find(user_id)
    @collection = Collection.find(collection_id)
    mail(to: @user.email,
         cc: 'ruestn+auk@gmail.com',
         subject: 'We had a problem downloading ' + @collection.title) do |format|
      format.text
      format.html
    end
  end
end
