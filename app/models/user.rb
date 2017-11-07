class User < ApplicationRecord
  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(
      provider: auth_hash.provider, uid: auth_hash.uid
    ).first_or_create
    user.update(
      name: auth_hash.info.nickname,
      profile_image: auth_hash.info.image,
      token: auth_hash.credentials.token,
      secret: auth_hash.credentials.secret
    )
    user
  end
end
