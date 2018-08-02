# frozen_string_literal: true

require 'test_helper'

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dashboard = dashboards(:one)
  end
end
