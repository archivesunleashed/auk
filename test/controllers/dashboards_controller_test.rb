# frozen_string_literal: true

require 'test_helper'

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dashboard_one = dashboards(:one)
    @dashboard_two = dashboards(:two)
  end

  test 'get dashboards index' do
    params = { test: 'object' }
    auth_headers = { "Authorization" => "Basic #{Base64.encode64('test:test')}" }
    get dashboards_path, params: params, as: :html
    assert_response 401
    get dashboards_path, params: params, as: :html, headers: auth_headers
    assert_response :success
  end
end
