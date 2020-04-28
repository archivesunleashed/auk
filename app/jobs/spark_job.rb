# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class SparkJob < ApplicationJob
  queue_as :spark

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
      queue: 'spark',
      start_time: DateTime.now.utc
    )
    Collection.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      collection_path = ENV['DOWNLOAD_PATH'] +
                        '/' + c.account.to_s +
                        '/' + c.collection_id.to_s + '/'
      collection_warcs = collection_path + 'warcs/*.gz'
      collection_derivatives = collection_path + c.user_id.to_s + '/derivatives'
      collection_logs = collection_path + c.user_id.to_s + '/logs'
      FileUtils.mkdir_p collection_logs
      FileUtils.rm_rf collection_derivatives
      FileUtils.mkdir_p collection_derivatives
      aut_version = ENV['AUT_VERSION']
      aut_jar_path = ENV['AUT_PATH']
      spark_home = ENV['SPARK_HOME']
      spark_heartbeat_interval = ENV['SPARK_HEARTBEAT_INTERVAL']
      spark_memory_driver = ENV['SPARK_MEMORY_DRIVER']
      spark_network_timeout = ENV['SPARK_NETWORK_TIMEOUT']
      spark_threads = ENV['SPARK_THREADS']

      spark_domains = spark_home +
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
                      '-fatjar.jar --extractor DomainFrequencyExtractor --input ' +
                      collection_warcs +
                      ' --output ' +
                      collection_derivatives +
                      '/all-domains/output 2>&1 | tee ' +
                      collection_logs +
                      '/' +
                      collection_id.to_s +
                      '-domains-' +
                      DateTime.now.utc.strftime('%Y%m%d%H%M') +
                      '.log'
      spark_text = spark_home +
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
                   '-fatjar.jar --extractor WebPagesExtractor --input ' +
                   collection_warcs +
                   ' --output ' +
                   collection_derivatives +
                   '/all-text/output 2>&1 | tee ' +
                   collection_logs +
                   '/' +
                   collection_id.to_s +
                   '-text-' +
                   DateTime.now.utc.strftime('%Y%m%d%H%M') +
                   '.log'

      spark_gephi = spark_home +
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
                    '/gephi  --output-format graphml 2>&1 | tee ' +
                    collection_logs +
                    '/' +
                    collection_id.to_s +
                    '-gephi-' +
                    DateTime.now.utc.strftime('%Y%m%d%H%M') +
                    '.log'

      Parallel.map([spark_domains, spark_text, spark_gephi], in_threads: 3) do |auk_job|
        system(auk_job)
        logger.info 'Executing: ' + auk_job
      end

      domain_success = collection_derivatives + '/all-domains/output/_SUCCESS'
      fulltext_success = collection_derivatives + '/all-text/output/_SUCCESS'
      graphml_success = collection_derivatives + '/gephi/GRAPHML.graphml'
      graphml = collection_derivatives +
                '/gephi/' +
                collection_id.to_s +
                '-gephi.graphml'
      if File.exist?(domain_success) && File.exist?(fulltext_success) &&
         File.exist?(graphml_success) && !File.empty?(graphml_success)
        FileUtils.mv(graphml_success, graphml)
        logger.info 'Executed: Domain Graph cleanup.'
        GraphpassJob.set(queue: :graphpass)
                    .perform_later(user_id, collection_id)
      else
        UserMailer.notify_collection_failed(c.user_id.to_s,
                                            c.collection_id.to_s).deliver_now
        raise 'Collections spark job failed.'
      end
    end
  end
end
