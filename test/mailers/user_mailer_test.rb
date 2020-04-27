# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'notify_collection_analyzed' do
    user = users(:one)
    collection = collections(:one)
    spark_name = 'Audio information extraction'
    mail = UserMailer.notify_collection_analyzed(user,
                                                 collection,
                                                 spark_name)
    assert_equal spark_name + ' on ' +
                 collection.title +
                 ' has finished!', mail.subject
  end

  test 'notify_collection_downloaded' do
    user = users(:one)
    collection = collections(:one)
    mail = UserMailer.notify_collection_downloaded(user.id, collection.id)
    assert_equal collection.title + ' has been downloaded!', mail.subject
  end

  test 'notify_collection_setup' do
    user = users(:one)
    mail = UserMailer.notify_collection_setup(user.id)
    assert_equal 'Your collections have been synced!', mail.subject
  end

  test 'notify_failed_analysis' do
    user = users(:one)
    collection = collections(:one)
    mail = UserMailer.notify_collection_failed(user.id, collection.id)
    assert_equal 'We had a problem analyzing Sample Collection', mail.subject
  end
end
