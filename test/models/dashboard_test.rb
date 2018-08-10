# frozen_string_literal: true

require 'test_helper'

class DashboardTest < ActiveSupport::TestCase
  def setup
    @dashboard_one = dashboards(:one)
    @dashboard_two = dashboards(:two)
  end

  test 'should be valid' do
    assert @dashboard_one.valid?
    assert @dashboard_two.valid?
  end
end
