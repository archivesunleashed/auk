# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(provider: 'github', uid: '1234', name: 'ruebot',
                     token: '12345', secret: '09876')
    @user_one = users(:one)
    @user_two = users(:two)
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

  test 'email should not be too long' do
    @user_one.email = 'a' * 244 + '@example.com'
    assert_not @user_one.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?,
             '#{valid_address.inspect} should be valid'
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user_one.email = invalid_address
      assert_not @user_one.valid?,
                 '#{invalid_address.inspect} should be invalid'
    end
  end

  test 'name should not be too long' do
    @user_one.auk_name = @user_one.name * 51
    assert_not @user_one.valid?
  end

  test 'institution should not be too long' do
    @user_two.institution = @user_two.institution * 76
    assert_not @user_two.valid?
  end
end
