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
      aut_jar_path = ENV['AUT_JAR_PATH']
      spark_driver_max_result_size = ENV['SPARK_DRIVER_MAXRESULTSIZE']
      spark_kryoserializer_buffer_max = ENV['SPARK_KRYOSERIALIZER_BUFFER_MAX']
      spark_memory_driver = ENV['SPARK_MEMORY_DRIVER']
      spark_network_timeout = ENV['SPARK_NETWORK_TIMEOUT']
      spark_rdd_compress = ENV['SPARK_RDD_COMPRESS']
      spark_serializer = ENV['SPARK_SERIALIZER']
      spark_shuffle_compress = ENV['SPARK_SHUFFLE_COMPRESS']
      spark_threads = ENV['SPARK_THREADS']
      spark_job = %(
      import io.archivesunleashed._
      import io.archivesunleashed.app._
      import io.archivesunleashed.matchbox._

      sc.setLogLevel("INFO")

      val statusCodes = Set("200")

      val validPages = RecordLoader
        .loadArchives("#{collection_warcs}", sc)
        .keepValidPages()
        .keepHttpStatus(statusCodes)

      validPages
        .map(r => ExtractDomainRDD(r.getUrl))
        .countItems()
        .saveAsTextFile("#{collection_derivatives}/all-domains/output")

      validPages
        .map(r => (r.getCrawlDate, r.getDomain, r.getUrl, RemoveHTMLRDD(RemoveHTTPHeaderRDD(r.getContentString))))
        .saveAsTextFile("#{collection_derivatives}/all-text/output")

      val links = validPages
                    .map(r => (r.getCrawlDate, ExtractLinksRDD(r.getUrl, r.getContentString)))
                    .flatMap(r => r._2.map(f => (r._1, ExtractDomainRDD(f._1).replaceAll("^\\\\s*www\\\\.", ""), ExtractDomainRDD(f._2).replaceAll("^\\\\s*www\\\\.", ""))))
                    .filter(r => r._2 != "" && r._3 != "")
                    .countItems()
                    .filter(r => r._2 > 5)

      WriteGraph.asGraphml(links, "#{collection_derivatives}/gephi/#{c.collection_id}-gephi.graphml")

      sys.exit
      )
      File.open(collection_spark_job_file, 'w') { |file| file.write(spark_job) }
      spark_job_cmd = spark_shell + ' --master local[' + spark_threads + '] --driver-memory ' + spark_memory_driver + ' --conf spark.network.timeout=' + spark_network_timeout + ' --conf spark.driver.maxResultSize=' + spark_driver_max_result_size + ' --conf spark.rdd.compress=' + spark_rdd_compress + ' --conf spark.serializer=' + spark_serializer + '  --conf spark.shuffle.compress=' + spark_shuffle_compress + ' --conf spark.kryoserializer.buffer.max=' + spark_kryoserializer_buffer_max + ' --jars ' + aut_jar_path + 'aut-' + aut_version + '-fatjar.jar -i ' + collection_spark_job_file + ' 2>&1 | tee ' + collection_spark_job_file + '.log'
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
