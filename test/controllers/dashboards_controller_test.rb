# frozen_string_literal: true

require 'test_helper'

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dashboard_one = dashboards(:one)
    @dashboard_two = dashboards(:two)
  end
end
