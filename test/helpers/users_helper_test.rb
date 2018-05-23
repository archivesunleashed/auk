# frozen_string_literal: true

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  def setup
    @user_one = users(:one)
    @user_two = users(:two)
  end

  test 'gravatar url helper' do
    assert_equal 'https://gravatar.com/avatar/8df8b5d5fccdafd0514fba299539b331.png?s=200', gravatar_url(@user_one.email, 200)
    assert_equal 'https://gravatar.com/avatar/b7e7642a5afced788bd300f5cd22506e.png?s=200&d=https%3A%2F%2Fuser-images.githubusercontent.com%2F218561%2F35773409-62e82b86-091f-11e8-8dec-188fc80c846b.jpg', gravatar_url(@user_two.email, 200)
  end
end
