# frozen_string_literal: true

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'],
           authorize_params: { use_authorize: 'true' }
end
