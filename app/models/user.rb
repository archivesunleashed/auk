# frozen_string_literal: true

# User model methods.
class User < ApplicationRecord
  has_many :wasapi_files
  has_many :collections
  def self.find_or_create_from_auth_hash(auth_hash)
    # OmniAuth.
    user = where(
      provider: auth_hash.provider, uid: auth_hash.uid
    ).first_or_create
    user.update(
      name: auth_hash.info.nickname,
      token: auth_hash.credentials.token,
      secret: auth_hash.credentials.secret
    )
    user
  end

  # Validate OmniAuth user.
  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true
  validates :token, presence: true

  # Setup Archive-It credential encryption.
  attr_encrypted :wasapi_username, key: ENV['WASAPI_KEY']
  attr_encrypted :wasapi_password, key: ENV['WASAPI_KEY']
end
