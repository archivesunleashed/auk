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

  test 'successful twitter sign-in' do
    get root_path
    assert_response :success
    assert_select 'span', 'Sign in with:'
    post '/auth/twitter'
    twitter_sign_in
    assert_response :redirect
  end

  test 'successful github sign-in' do
    get root_path
    assert_response :success
    assert_select 'span', 'Sign in with:'
    post '/auth/github'
    github_sign_in
    assert_response :redirect
  end
end
