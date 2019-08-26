# frozen_string_literal: true

# Users helper methods.
module UsersHelper
  def gravatar_url(email, size)
    if email.present?
      gravatar = Digest::MD5.hexdigest(email).downcase
      "https://gravatar.com/avatar/#{gravatar}.png?s=#{size}"
    elsif email.nil?
      email = 'noreply@archivesunleashed.org'
      gravatar = Digest::MD5.hexdigest(email).downcase
      default_url = 'https://user-images.githubusercontent.com/218561/35773409-62e82b86-091f-11e8-8dec-188fc80c846b.jpg'
      "https://gravatar.com/avatar/#{gravatar}.png?s=#{size}&d=#{CGI.escape(default_url)}"
    end
  end

  def collection_queued(user_id, collection_id)
    Delayed::Job.where("handler LIKE '%#{user_id}%' AND handler LIKE '%#{collection_id}%'")
                .pluck(:queue)
  end
end
