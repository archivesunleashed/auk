# frozen_string_literal: true

require 'test_helper'

class WasapiFilesHelperTest < ActionView::TestCase
  def setup
    @wasapi_files_one = wasapi_files(:one)
    @wasapi_files_two = wasapi_files(:two)
  end

  test 'collection count helper' do
    assert_equal 2, collection_count(@wasapi_files_one.collection_id,
                                     @wasapi_files_one.user_id)
    assert_equal 2, collection_count(@wasapi_files_two.collection_id,
                                     @wasapi_files_two.user_id)
  end

  test 'collection size human helper' do
    assert_equal '650 KB',
                 collection_size_human(@wasapi_files_one.collection_id,
                                       @wasapi_files_one.user_id)
    assert_equal '650 KB',
                 collection_size_human(@wasapi_files_two.collection_id,
                                       @wasapi_files_two.user_id)
  end

  test 'collection size helper' do
    assert_equal 666_068, collection_size(@wasapi_files_one.collection_id,
                                          @wasapi_files_one.user_id)
    assert_equal 666_068, collection_size(@wasapi_files_two.collection_id,
                                          @wasapi_files_two.user_id)
  end
end
