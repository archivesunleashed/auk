# frozen_string_literal: true

require 'test_helper'

class CollectionsHelperTest < ActionView::TestCase
  def setup
    ENV['DOWNLOAD_PATH'] = 'test/fixtures/files'
    @collections_one = collections(:one)
    @collections_two = collections(:two)
  end

  test 'gexf path helper' do
    assert_equal 'test/fixtures/files/401/1234/1/derivatives/gephi/1234-gephi.gexf',
                 gexf_path(@collections_one.user_id,
                           @collections_one.collection_id,
                           @collections_one.account)
    assert_equal 'test/fixtures/files/990/6275/2/derivatives/gephi/6275-gephi.gexf',
                 gexf_path(@collections_two.user_id,
                           @collections_two.collection_id,
                           @collections_two.account)
  end

  test 'graphml path helper' do
    assert_equal 'test/fixtures/files/401/1234/1/derivatives/gephi/1234-gephi.graphml',
                 graphml_path(@collections_one.user_id,
                              @collections_one.collection_id,
                              @collections_one.account)
    assert_equal 'test/fixtures/files/990/6275/2/derivatives/gephi/6275-gephi.graphml',
                 graphml_path(@collections_two.user_id,
                              @collections_two.collection_id,
                              @collections_two.account)
  end

  test 'fulltext path helper' do
    assert_equal 'test/fixtures/files/401/1234/1/derivatives/all-text/1234-fulltext.txt',
                 fulltext_path(@collections_one.user_id,
                               @collections_one.collection_id,
                               @collections_one.account)
    assert_equal 'test/fixtures/files/990/6275/2/derivatives/all-text/6275-fulltext.txt',
                 fulltext_path(@collections_two.user_id,
                               @collections_two.collection_id,
                               @collections_two.account)
  end

  test 'domains path helper' do
    assert_equal 'test/fixtures/files/401/1234/1/derivatives/all-domains/1234-fullurls.txt',
                 domains_path(@collections_one.user_id,
                              @collections_one.collection_id,
                              @collections_one.account)
    assert_equal 'test/fixtures/files/990/6275/2/derivatives/all-domains/6275-fullurls.txt',
                 domains_path(@collections_two.user_id,
                              @collections_two.collection_id,
                              @collections_two.account)
  end

  test 'display domains helper' do
    assert_nil display_domains(@collections_one.user_id,
                               @collections_one.collection_id,
                               @collections_one.account)
    assert_equal [['archivesunleashed.org', '10000']],
                 display_domains(@collections_two.user_id,
                                 @collections_two.collection_id,
                                 @collections_two.account)
  end

  test 'filtered text path helper' do
    assert_equal 'test/fixtures/files/401/1234/1/derivatives/filtered-text/1234-filtered_text.zip',
                 textfilter_path(@collections_one.user_id,
                                 @collections_one.collection_id,
                                 @collections_one.account)
    assert_equal 'test/fixtures/files/990/6275/2/derivatives/filtered-text/6275-filtered_text.zip',
                 textfilter_path(@collections_two.user_id,
                                 @collections_two.collection_id,
                                 @collections_two.account)
  end
end
