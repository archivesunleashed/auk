# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path
    assert_response :success
    assert_select 'title', 'Archives Unleashed'
  end

  test 'should get about page' do
    get about_path
    assert_response :success
    assert_select 'title', 'About | Archives Unleashed'
  end
end
