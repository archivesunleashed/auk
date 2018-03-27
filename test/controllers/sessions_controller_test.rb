# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'not signed in' do
    get root_path
    assert_response :success
    assert_select 'span', 'Sign in with:'
    assert_select 'i', ''
    assert_select 'i', ''
  end

  test 'successful sign-in' do
    get root_path
    assert_response :success
    assert_select 'span', 'Sign in with:'
    OmniAuth.config.mock_auth[:github]
    get root_path
    assert_response :success
    assert_select 'strong', 'AU Cloud Account'
  end
end
