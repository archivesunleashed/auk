# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @collections_one = collections(:one)
    @collections_two = collections(:two)
    @dashboards_one = dashboards(:one)
    @dashboards_two = dashboards(:two)
  end

  test 'get archive-it collection url' do
    assert_equal 'https://archive-it.org/collections/1234',
                 archiveit_collection_url(@collections_one.collection_id)
    assert_equal 'https://archive-it.org/collections/3490',
                 archiveit_collection_url(@collections_two.collection_id)
  end

  test 'get amount of jobs a user has run' do
    assert_equal 0, user_jobs_run(@dashboards_one.user_id)
    assert_equal 0, user_jobs_run(@dashboards_two.user_id)
  end
end
