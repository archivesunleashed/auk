# frozen_string_literal: true

# Methods for Domain Graph Extrator.
class DomaingraphJob < ApplicationJob
  queue_as :domaingraph

  after_perform do
    update_dashboard = Dashboard.find_by(job_id: job_id)
    update_dashboard.end_time = DateTime.now.utc
    update_dashboard.save
  end

  def perform(user_id, collection_id)
    Dashboard.find_or_create_by!(
      job_id: job_id,
      user_id: user_id.id.to_i,
      collection_id: collection_id.id.to_i,
      queue: 'domaingraph',
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
      FileUtils.rm_rf collection_derivatives + '/domaingraph'
      aut_version = ENV['AUT_VERSION']
      aut_jar_path = ENV['AUT_PATH']
      spark_heartbeat_interval = ENV['SPARK_HEARTBEAT_INTERVAL']
      spark_memory_driver = ENV['SPARK_MEMORY_DRIVER']
      spark_network_timeout = ENV['SPARK_NETWORK_TIMEOUT']
      spark_threads = ENV['SPARK_THREADS']
      spark_log = ENV['SPARK_LOG_PATH']
      domaingraph_job = spark_home +
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
                        '-fatjar.jar --extractor DomainGraphExtractor --input ' +
                        collection_warcs +
                        ' --output ' +
                        collection_derivatives +
                        '/domaingraph --output-format graphml 2>&1 | tee ' +
                        spark_log +
                        '/' +
                        collection_id.id.to_s +
                        '-domaingraph-' +
                        DateTime.now.utc.strftime('%Y%m%d%H%M') +
                        '.log'
      logger.info 'Executing: ' + domaingraph_job
      system(domaingraph_job)
      success = collection_derivatives + '/domaingraph/GRAPHML.graphml'
      graphml = collection_derivatives +
               '/domaingraph/' +
                collection_id.id.to_s +
               '.graphml'
      if File.exist?(success)
        FileUtils.mv(success, graphml)
        logger.info 'Executed: Domain Graph cleanup.'
      else
        UserMailer.notify_collection_failed(c.user_id.to_s,
                                            c.collection_id.to_s).deliver_now
        raise 'Domain Graph spark job failed.'
      end
    end
  end
end
