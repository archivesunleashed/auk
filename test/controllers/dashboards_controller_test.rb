# frozen_string_literal: true

require 'test_helper'

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dashboard_one = dashboards(:one)
    @dashboard_two = dashboards(:two)
  end

  test 'get dashboards index' do
    params = { dashboard: {
      job_id: '1abas', user_id: '298486374', collection_id: '1234',
      queue: 'download', start_time: '2018-08-01 08:48:01',
      end_time: '2018-08-12 06:18:01'
    } }
    auth_headers = { "Authorization" => "Basic #{Base64.encode64('test:test')}" }
    get dashboards_path, params: params, as: :html
    assert_response 401
    get dashboards_path, params: params, as: :html, headers: auth_headers
    assert_response :success
    assert_select 'td', 'Sample Collection'
  end
end
