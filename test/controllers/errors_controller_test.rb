# frozen_string_literal: true

require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path
    assert_response :success
    assert_select 'title', 'Archives Unleashed'
  end

  test 'should get 404 page' do
    get '/404'
    assert_response :missing
    assert_select 'img' do
      assert_select '[class=?]', 'center'
    end
  end

  test 'should get 422 page' do
    get '/422'
    assert_response 422
    assert_select 'img' do
      assert_select '[class=?]', 'center'
    end
  end

  test 'should get 500 page' do
    get '/500'
    assert_response 500
    assert_select 'img' do
      assert_select '[class=?]', 'center'
    end
  end
end
