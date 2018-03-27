# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user_one = users(:one)
    @user_two = users(:two)
  end

  test 'should redirect index when not logged in' do
    get user_path(@user_one)
    assert_redirected_to root_path
  end
end
