# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class CollectionsCatJob < ApplicationJob
  queue_as :spark_cat

  def perform(user_id, collection_id)
    Collection.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      collection_path = ENV['DOWNLOAD_PATH'] +
                        '/' + c.account.to_s +
                        '/' + c.collection_id.to_s + '/'
      collection_derivatives = collection_path + c.user_id.to_s + '/derivatives'
      combine_full_url_output_cmd = 'cat ' + collection_derivatives + '/all-domains/output/part* > ' + collection_derivatives + '/all-domains/' + c.collection_id.to_s + '-fullurls.txt'
      logger.info 'Executing: ' + combine_full_url_output_cmd
      system(combine_full_url_output_cmd)
      successful_job = collection_derivatives + '/all-domains/' + c.collection_id.to_s + '-fullurls.txt'
      if File.exist?(successful_job) && !File.empty?(successful_job)
        FileUtils.rm_rf(collection_derivatives + '/all-domains/output')
      else
        raise 'Collections cat domains job failed.'
      end
      combine_full_text_output_cmd = 'cat ' + collection_derivatives + '/all-text/output/part* > ' + collection_derivatives + '/all-text/' + c.collection_id.to_s + '-fulltext.txt'
      logger.info 'Executing: ' + combine_full_text_output_cmd
      system(combine_full_text_output_cmd)
      if File.exist?(successful_job) && !File.empty?(successful_job)
        FileUtils.rm_rf(collection_derivatives + '/all-text/output')
      else
        raise 'Collections cat full text job failed.'
      end
    end
  end
end
