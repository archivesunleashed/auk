# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class WarcsCleanupJob < ApplicationJob
  queue_as :cleanup

  def perform(user_id, collection_id)
    Collection.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      warcs_path = ENV['DOWNLOAD_PATH'] +
                   '/' + c.account.to_s +
                   '/' + c.collection_id.to_s + '/warcs'
      logger.info 'Removing warcs for collection: ' + c.collection_id.to_s
      FileUtils.rm_rf(warcs_path)
    end
  end
end
