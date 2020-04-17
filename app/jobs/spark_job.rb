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
    spark_shell = ENV['SPARK_SHELL']
    Collection.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      collection_path = ENV['DOWNLOAD_PATH'] +
                        '/' + c.account.to_s +
                        '/' + c.collection_id.to_s + '/'
      collection_warcs = collection_path + 'warcs/*.gz'
      collection_derivatives = collection_path + c.user_id.to_s + '/derivatives'
      collection_spark_jobs_path = collection_path + c.user_id.to_s + '/spark_jobs'
      collection_spark_job_file = collection_spark_jobs_path + '/' + c.collection_id.to_s + '.scala'
      FileUtils.rm_rf collection_derivatives
      FileUtils.rm_rf collection_spark_jobs_path
      FileUtils.mkdir_p collection_derivatives
      FileUtils.mkdir_p collection_spark_jobs_path
      FileUtils.mkdir_p collection_derivatives + '/gephi'
      aut_version = ENV['AUT_VERSION']
      spark_driver_max_result_size = ENV['SPARK_DRIVER_MAXRESULTSIZE']
      spark_heartbeat_interval = ENV['SPARK_HEARTBEAT_INTERVAL']
      spark_kryoserializer_buffer_max = ENV['SPARK_KRYOSERIALIZER_BUFFER_MAX']
      spark_memory_driver = ENV['SPARK_MEMORY_DRIVER']
      spark_network_timeout = ENV['SPARK_NETWORK_TIMEOUT']
      spark_rdd_compress = ENV['SPARK_RDD_COMPRESS']
      spark_serializer = ENV['SPARK_SERIALIZER']
      spark_shuffle_compress = ENV['SPARK_SHUFFLE_COMPRESS']
      spark_threads = ENV['SPARK_THREADS']
      spark_job = %(
      import io.archivesunleashed._
      import io.archivesunleashed.df._
      import io.archivesunleashed.app._

      sc.setLogLevel("INFO")

      val webpages = RecordLoader.loadArchives("#{collection_warcs}", sc).webpages()
      val webgraph = RecordLoader.loadArchives("#{collection_warcs}", sc).webgraph()

      webpages.groupBy(ExtractDomainDF($"Url").alias("url"))
        .count()
        .sort($"count".desc)
        .write.csv("#{collection_derivatives}/all-domains/output")

      webpages.select($"crawl_date", RemovePrefixWWWDF(ExtractDomainDF(($"url")).alias("domain")), $"url", RemoveHTMLDF(RemoveHTTPHeaderDF(($"content"))))
        .write.csv("#{collection_derivatives}/all-text/output")

      val graph = webgraph.groupBy(
                            $"crawl_date",
                            RemovePrefixWWWDF(ExtractDomainDF($"src")).as("src_domain"),
                            RemovePrefixWWWDF(ExtractDomainDF($"dest")).as("dest_domain"))
                    .count()
                    .filter(!($"dest_domain"===""))
                    .filter(!($"src_domain"===""))
                    .filter($"count" > 5)
                    .orderBy(desc("count"))

      WriteGraphML(graph.collect(), "#{collection_derivatives}/gephi/#{c.collection_id}-gephi.graphml")

      sys.exit
      )
      File.open(collection_spark_job_file, 'w') { |file| file.write(spark_job) }
      spark_job_cmd = spark_shell + ' --master local[' + spark_threads + '] --driver-memory ' + spark_memory_driver + ' --conf spark.network.timeout=' + spark_network_timeout + ' --conf spark.executor.heartbeatInterval=' + spark_heartbeat_interval + ' --conf spark.driver.maxResultSize=' + spark_driver_max_result_size + ' --conf spark.rdd.compress=' + spark_rdd_compress + ' --conf spark.serializer=' + spark_serializer + '  --conf spark.shuffle.compress=' + spark_shuffle_compress + ' --conf spark.kryoserializer.buffer.max=' + spark_kryoserializer_buffer_max + ' --packages "io.archivesunleashed:aut:' + aut_version + '" -i ' + collection_spark_job_file + ' 2>&1 | tee ' + collection_spark_job_file + '.log'
      logger.info 'Executing: ' + spark_job_cmd
      system(spark_job_cmd)
      domain_success = collection_derivatives + '/all-domains/output/_SUCCESS'
      fulltext_success = collection_derivatives + '/all-text/output/_SUCCESS'
      graphml_success = collection_derivatives + '/gephi/' +
                        c.collection_id.to_s + '-gephi.graphml'
      if File.exist?(domain_success) && File.exist?(fulltext_success) &&
         File.exist?(graphml_success) && !File.empty?(graphml_success)
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
