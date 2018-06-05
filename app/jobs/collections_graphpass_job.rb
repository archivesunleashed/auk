# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class CollectionsGraphpassJob < ApplicationJob
  queue_as :graphpass

  after_perform do |job|
    UserMailer.notify_collection_analyzed(job.arguments.first,
                                          job.arguments.second).deliver_now
    WarcsCleanupJob.set(wait: 1.day).perform_later(job.arguments.first,
                                                   job.arguments.second)
  end

  def perform(user_id, collection_id)
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
      successful_job = collection_derivatives + '/gephi/' + c.collection_id.to_s + '-gephi.gexf'
      unless File.exist? successful_job
        raise 'Collections graphpass job failed.'
      end
    end
  end
end
