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
      combine_full_url_output_cmd = 'find ' + collection_derivatives + '/all-domains/output -iname "part*" -type f -exec cat {} > ' + collection_derivatives + '/all-domains/' + c.collection_id.to_s + '-fullurls.csv \;'
      combine_full_text_output_cmd = 'find ' + collection_derivatives + '/all-text/output -iname "part*" -type f -exec cat {} > ' + collection_derivatives + '/all-text/' + c.collection_id.to_s + '-fulltext.csv \;'
      # Run GraphPass, and combine part files in parallel.
      Parallel.map([graphpass_cmd, combine_full_url_output_cmd, combine_full_text_output_cmd], in_threads: 3) do |auk_job|
        logger.info 'Executing: ' + auk_job
        system(auk_job)
      end
      # Cleanup part files in parallel.
      domains_cleanup = FileUtils.rm_rf(collection_derivatives + '/all-domains/output')
      fulltext_cleanup = FileUtils.rm_rf(collection_derivatives + '/all-text/output')
      Parallel.map([domains_cleanup, fulltext_cleanup], in_threads: 2) do |auk_job|
        logger.info 'Executing: part file cleanup for ' +
                    c.account.to_s + '-' +
                    c.collection_id.to_s +
                    '.'
        auk_job
      end
      TextfilterJob.set(queue: :textfilter)
                   .perform_later(user_id, collection_id)
    end
  end
end
