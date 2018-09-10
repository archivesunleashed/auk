# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class CleanupJob < ApplicationJob
  queue_as :cleanup

  after_perform do
    update_dashboard = Dashboard.find_by(job_id: job_id)
    update_dashboard.end_time = DateTime.now.utc
    update_dashboard.save
  end

  def perform(user_id, collection_id)
    Dashboard.find_or_create_by!(
      job_id: job_id,
      user_id: user_id,
      collection_id: collection_id,
      queue: 'cleanup',
      start_time: DateTime.now.utc
    )
    Collection.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      warcs_path = ENV['DOWNLOAD_PATH'] +
                   '/' + c.account.to_s +
                   '/' + c.collection_id.to_s + '/warcs'
      logger.info 'Removing warcs for collection: ' + c.collection_id.to_s
      FileUtils.rm_rf(warcs_path)
    end
  end
end
