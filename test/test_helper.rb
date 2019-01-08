# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

# Test helper methods.
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in
  # alphabetical order.
  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end

  def twitter_sign_in
    OmniAuth.config.mock_auth[:twitter]
  end

  def github_sign_in
    OmniAuth.config.mock_auth[:github]
  end
end
