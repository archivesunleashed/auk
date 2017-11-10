# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(provider: 'github', uid: '1234', name: 'ruebot',
                     token: '12345', secret: '09876')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'provider should be present' do
    @user.provider = ''
    assert_not @user.valid?
  end

  test 'uid should be present' do
    @user.uid = ''
    assert_not @user.valid?
  end

  test 'name should be present' do
    @user.name = ''
    assert_not @user.valid?
  end

  test 'token should be present' do
    @user.token = ''
    assert_not @user.valid?
  end

  test 'secret should be present' do
    @user.secret = ''
    assert_not @user.valid?
  end
end
