# frozen_string_literal: true

require 'test_helper'

class DashboardsHelperTest < ActionView::TestCase
  def setup
    @dashboards_one = dashboards(:one)
    @dashboards_two = dashboards(:two)
  end

  test 'job length helper' do
    assert_equal '1 Week, 3 Days, 21 Hours and 30 Minutes',
                 job_length(@dashboards_one.start_time,
                            @dashboards_one.end_time)
    assert_equal '18 Hours, 56 Minutes and 4 Seconds',
                 job_length(@dashboards_two.start_time,
                            @dashboards_two.end_time)
  end

  test 'get username helper' do
    assert_equal 'Nacho Nicolas',
                 get_username(@dashboards_one.user_id)
    assert_equal 'Rick Ruebeau',
                 get_username(@dashboards_two.user_id)
  end

  test 'get institution helper' do
    assert_equal 'York University',
                 get_institution(@dashboards_one.user_id)
    assert_equal 'York University',
                 get_institution(@dashboards_two.user_id)
  end

  test 'get collection name helper' do
    assert_equal 'Sample Collection',
                 get_collection_name(@dashboards_one.collection_id)
    assert_equal 'Archives Unleashed',
                 get_collection_name(@dashboards_two.collection_id)
  end
end
