# frozen_string_literal: true

# Users helper methods.
module UsersHelper
  def gravatar_url(email, size)
    if email.present?
      gravatar = Digest::MD5.hexdigest(email).downcase
      "http://gravatar.com/avatar/#{gravatar}.png?s=#{size}"
    elsif email.nil?
      email = 'noreply@archivesunleashed.org'
      gravatar = Digest::MD5.hexdigest(email).downcase
      default_url = 'https://camo.githubusercontent.com/148a43ac461f352346f8cd894af8bb5845a831fb/68747470733a2f2f7777772e6f6c64626f6f6b696c6c757374726174696f6e732e636f6d2f77702d636f6e74656e742f686967682d7265732f313836372f6772616e6476696c6c652d61756b2d313630302e6a7067'
      "http://gravatar.com/avatar/#{gravatar}.png?s=#{size}&d=#{CGI.escape(default_url)}"
    end
  end
end
