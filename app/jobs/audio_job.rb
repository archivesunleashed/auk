# frozen_string_literal: true

# Methods for Audio Information Extrator.
class AudioJob < ApplicationJob
  queue_as :audio

  after_perform do |job|
    spark_name = 'Audio information extraction'
    UserMailer.notify_collection_analyzed(job.arguments.first,
                                          job.arguments.second,
                                          spark_name).deliver_now
    update_dashboard = Dashboard.find_by(job_id: job_id)
    update_dashboard.end_time = DateTime.now.utc
    update_dashboard.save
    if Rails.env.production?
      user = User.find(job.arguments.first)
      collection = Collection.find(job.arguments.second)
      message = "#{spark_name} on \"#{collection.title}\" for #{user.auk_name} has completed."
      SLACK.ping message
    end
  end

  def perform(user_id, collection_id)
    Dashboard.find_or_create_by!(
      job_id: job_id,
      user_id: user_id.id.to_i,
      collection_id: collection_id.id.to_i,
      queue: 'audio',
      start_time: DateTime.now.utc
    )
    spark_home = ENV['SPARK_HOME']
    Collection.where('user_id = ? AND collection_id = ?',
                     user_id.id, collection_id.id).each do |c|
      collection_path = ENV['DOWNLOAD_PATH'] +
                        '/' + c.account.to_s +
                        '/' + c.collection_id.to_s + '/'
      collection_warcs = collection_path + 'warcs'
      collection_derivatives = collection_path + c.user_id.to_s +
                               '/derivatives'
      FileUtils.rm_rf collection_derivatives + '/audio'
      aut_version = ENV['AUT_VERSION']
      aut_jar_path = ENV['AUT_PATH']
      spark_heartbeat_interval = ENV['SPARK_HEARTBEAT_INTERVAL']
      spark_memory_driver = ENV['SPARK_MEMORY_DRIVER']
      spark_network_timeout = ENV['SPARK_NETWORK_TIMEOUT']
      spark_threads = ENV['SPARK_THREADS']
      spark_log = ENV['SPARK_LOG_PATH']
      audio_job = spark_home +
                  '/bin/spark-submit --master local[' +
                  spark_threads +
                  '] --driver-memory ' +
                  spark_memory_driver +
                  ' --conf spark.network.timeout=' +
                  spark_network_timeout +
                  ' --conf spark.executor.heartbeatInterval=' +
                  spark_heartbeat_interval +
                  ' --conf spark.driver.maxResultSize=0 --class io.archivesunleashed.app.CommandLineAppRunner ' +
                  aut_jar_path +
                  '/aut-' +
                  aut_version +
                  '-fatjar.jar --extractor AudioInformationExtractor --input ' +
                  collection_warcs +
                  ' --output ' +
                  collection_derivatives +
                  '/audio --partition 1 2>&1 | tee ' +
                  spark_log +
                  '/' +
                  collection_id.id.to_s +
                  '-audio-' +
                  DateTime.now.utc.strftime('%Y%m%d%H%M') +
                  '.log'
      logger.info 'Executing: ' + audio_job
      system(audio_job)
      success = collection_derivatives + '/audio/_SUCCESS'
      combine = 'find ' +
                collection_derivatives +
                '/audio -iname "part*" -type f -exec cat {} > ' +
                collection_derivatives +
                '/audio/' +
                c.collection_id.to_s +
                '-audio.csv \;'
      cleanup = 'find ' +
                collection_derivatives +
                '/audio -iname "part*" -type f -delete'
      hidden = 'find ' +
               collection_derivatives +
               '/audio -iname ".*" -type f -delete'
      if File.exist?(success)
        system(combine)
        FileUtils.rm(success)
        system(cleanup)
        system(hidden)
        logger.info 'Executed: Audio information cleanup.'
      else
        UserMailer.notify_collection_failed(c.user_id.to_s,
                                            c.collection_id.to_s).deliver_now
        raise 'Audio information spark job failed.'
      end
    end
  end
end
