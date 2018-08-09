# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class CollectionsGraphpassJob < ApplicationJob
  queue_as :graphpass

  after_perform do |job|
    UserMailer.notify_collection_analyzed(job.arguments.first,
                                          job.arguments.second).deliver_now
    WarcsCleanupJob.set(wait: 1.day).perform_later(job.arguments.first,
                                                   job.arguments.second)
    update_dashboard = Dashboard.find_by(job_id: job_id)
    update_dashboard.end_time = DateTime.now.utc
    update_dashboard.save
  end

  def perform(user_id, collection_id)
    Dashboard.find_or_create_by!(
      job_id: job_id,
      user_id: user_id,
      collection_id: collection_id,
      queue: 'graphpass',
      start_time: DateTime.now.utc
    )
    graphpass = ENV['GRAPHPASS']
    Collection.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      collection_path = ENV['DOWNLOAD_PATH'] +
                        '/' + c.account.to_s +
                        '/' + c.collection_id.to_s + '/'
      collection_derivatives = collection_path + c.user_id.to_s + '/derivatives'
      graphpass_flags = " --file #{c.collection_id}-gephi.graphml --output #{collection_derivatives}/gephi/ --dir #{collection_derivatives}/gephi/ -g -q"
      graphpass_cmd = graphpass + graphpass_flags
      logger.info 'Executing: ' + graphpass_cmd
      system(graphpass_cmd)
      combine_full_url_output_cmd = 'cat ' + collection_derivatives + '/all-domains/output/part* > ' + collection_derivatives + '/all-domains/' + c.collection_id.to_s + '-fullurls.txt'
      logger.info 'Executing: ' + combine_full_url_output_cmd
      system(combine_full_url_output_cmd)
      FileUtils.rm_rf(collection_derivatives + '/all-domains/output')
      combine_full_text_output_cmd = 'cat ' + collection_derivatives + '/all-text/output/part* > ' + collection_derivatives + '/all-text/' + c.collection_id.to_s + '-fulltext.txt'
      logger.info 'Executing: ' + combine_full_text_output_cmd
      system(combine_full_text_output_cmd)
      FileUtils.rm_rf(collection_derivatives + '/all-text/output')
    end
  end
end
