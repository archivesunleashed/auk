# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path
    assert_response :success
    assert_select 'title', 'Archives Unleashed'
  end

  test 'should get about page' do
    get about_path
    assert_response :success
    assert_select 'title', 'About | Archives Unleashed'
  end

  test 'should get documentation page' do
    get documentation_path
    assert_response :success
    assert_select 'title', 'Documentation | Archives Unleashed'
  end

  test 'should get faq page' do
    get faq_path
    assert_response :success
    assert_select 'title', 'FAQ | Archives Unleashed'
  end

  test 'should get privacy policy page' do
    get privacypolicy_path
    assert_response :success
    assert_select 'title', 'Privacy Policy | Archives Unleashed'
  end

  test 'should get derivatives page' do
    get derivatives_path
    assert_response :success
    assert_select 'title', 'Derivatives | Archives Unleashed'
  end

  test 'should get network graphing page' do
    get derivatives_domains_path
    assert_response :success
    assert_select 'title', 'Making sense of the domains count | Archives Unleashed'
  end

  test 'should get gephi page' do
    get derivatives_gephi_path
    assert_response :success
    assert_select 'title', 'Network Graphing with Gephi | Archives Unleashed'
  end

  test 'should get filtering page' do
    get derivatives_text_filtering_path
    assert_response :success
    assert_select 'title', 'Filtering the Full-Text Derivative File | Archives Unleashed'
  end

  test 'should get antconc page' do
    get derivatives_text_antconc_path
    assert_response :success
    assert_select 'title', 'Beyond the Keyword Search: Using AntConc for Text Analysis | Archives Unleashed'
  end

  test 'should get nlk page' do
    get derivatives_text_sentiment_path
    assert_response :success
    assert_select 'title', 'Sentiment Analysis With the Natural Language Toolkit | Archives Unleashed'
  end
end
