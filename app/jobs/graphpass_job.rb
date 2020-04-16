# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class GraphpassJob < ApplicationJob
  queue_as :graphpass

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
      queue: 'graphpass',
      start_time: DateTime.now.utc
    )
    graphpass = ENV['GRAPHPASS']
    Collection.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      collection_path = ENV['DOWNLOAD_PATH'] +
                        '/' + c.account.to_s +
                        '/' + c.collection_id.to_s + '/'
      collection_derivatives = collection_path + c.user_id.to_s + '/derivatives'
      graphpass_flags = " #{collection_derivatives}/gephi/#{c.collection_id}-gephi.graphml #{collection_derivatives}/gephi/#{c.collection_id}-gephi.gexf -gq"
      graphpass_cmd = graphpass + graphpass_flags
      logger.info 'Executing: ' + graphpass_cmd
      system(graphpass_cmd)
      combine_full_url_output_cmd = 'find ' + collection_derivatives + '/all-domains/output -iname "part*" -type f -exec cat {} > ' + collection_derivatives + '/all-domains/' + c.collection_id.to_s + '-fullurls.csv \;'
      logger.info 'Executing: ' + combine_full_url_output_cmd
      system(combine_full_url_output_cmd)
      FileUtils.rm_rf(collection_derivatives + '/all-domains/output')
      combine_full_text_output_cmd = 'find ' + collection_derivatives + '/all-text/output -iname "part*" -type f -exec cat {} > ' + collection_derivatives + '/all-text/' + c.collection_id.to_s + '-fulltext.csv \;'
      logger.info 'Executing: ' + combine_full_text_output_cmd
      system(combine_full_text_output_cmd)
      FileUtils.rm_rf(collection_derivatives + '/all-text/output')
      TextfilterJob.set(queue: :textfilter)
                   .perform_later(user_id, collection_id)
    end
  end
end
