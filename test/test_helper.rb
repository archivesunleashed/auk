# frozen_string_literal: true

require File.expand_path('../../config/environment', __FILE__)
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
end
