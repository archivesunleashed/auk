# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @collections_one = collections(:one)
    @collections_two = collections(:two)
  end

  test 'get archive-it collection url' do
    assert_equal 'https://archive-it.org/collections/1234',
                 archiveit_collection_url(@collections_one.collection_id)
    assert_equal 'https://archive-it.org/collections/3490',
                 archiveit_collection_url(@collections_two.collection_id)
  end
end
