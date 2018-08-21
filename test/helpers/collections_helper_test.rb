# frozen_string_literal: true

require 'test_helper'

class CollectionsHelperTest < ActionView::TestCase
  def setup
    ENV['DOWNLOAD_PATH'] = '/tmp'
    @collections_one = collections(:one)
    @collections_two = collections(:two)
  end

  test 'gexf path helper' do
    assert_equal '/tmp/401/1234/1/derivatives/gephi/1234-gephi.gexf',
                 gexf_path(@collections_one.user_id,
                           @collections_one.collection_id,
                           @collections_one.account)
    assert_equal '/tmp/401/3490/2/derivatives/gephi/3490-gephi.gexf',
                 gexf_path(@collections_two.user_id,
                           @collections_two.collection_id,
                           @collections_two.account)
  end

  test 'graphml path helper' do
    assert_equal '/tmp/401/1234/1/derivatives/gephi/1234-gephi.graphml',
                 graphml_path(@collections_one.user_id,
                              @collections_one.collection_id,
                              @collections_one.account)
    assert_equal '/tmp/401/3490/2/derivatives/gephi/3490-gephi.graphml',
                 graphml_path(@collections_two.user_id,
                              @collections_two.collection_id,
                              @collections_two.account)
  end

  test 'fulltext path helper' do
    assert_equal '/tmp/401/1234/1/derivatives/all-text/1234-fulltext.txt',
                 fulltext_path(@collections_one.user_id,
                               @collections_one.collection_id,
                               @collections_one.account)
    assert_equal '/tmp/401/3490/2/derivatives/all-text/3490-fulltext.txt',
                 fulltext_path(@collections_two.user_id,
                               @collections_two.collection_id,
                               @collections_two.account)
  end

  test 'domains path helper' do
    assert_equal '/tmp/401/1234/1/derivatives/all-domains/1234-fullurls.txt',
                 domains_path(@collections_one.user_id,
                              @collections_one.collection_id,
                              @collections_one.account)
    assert_equal '/tmp/401/3490/2/derivatives/all-domains/3490-fullurls.txt',
                 domains_path(@collections_two.user_id,
                              @collections_two.collection_id,
                              @collections_two.account)
  end
end
