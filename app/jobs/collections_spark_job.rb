# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class CollectionsSparkJob < ApplicationJob
  queue_as :default
  require 'open-uri'

  after_perform do |job|
    UserMailer.notify_collection_analyzed(job.arguments.first.id,
                                          job.arguments.second.id).deliver_now
    logger.info 'Email sent to: ' + job.arguments.first.email.to_s
  end

  def perform(user_id, collection_id)
    spark_shell = ENV['SPARK_SHELL']
    Collection.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      collection_path = ENV['DOWNLOAD_PATH'] +
                        '/' + c.account.to_s +
                        '/' + c.collection_id.to_s + '/'
      collection_warcs = collection_path + 'warcs/*.gz'
      collection_derivatives = collection_path + c.user_id.to_s + '/derivatives'
      collection_spark_jobs_path = collection_path + c.user_id.to_s + '/spark_jobs'
      collection_spark_job_file = collection_spark_jobs_path + '/' + c.collection_id.to_s + '.scala'
      FileUtils.mkdir_p collection_derivatives
      FileUtils.mkdir_p collection_spark_jobs_path
      FileUtils.mkdir_p collection_derivatives + '/gephi'
      spark_memory_driver = ENV['SPARK_MEMORY_DRIVER']
      spark_network_timeout = ENV['SPARK_NETWORK_TIMEOUT']
      aut_version = ENV['AUT_VERSION']
      spark_job = %(
      import io.archivesunleashed.spark.matchbox.{ExtractDomain, ExtractLinks, RemoveHTML, RecordLoader, WriteGEXF}
      import io.archivesunleashed.spark.rdd.RecordRDD._
      sc.setLogLevel("INFO")
      RecordLoader.loadArchives("#{collection_warcs}", sc).keepValidPages().map(r => ExtractDomain(r.getUrl)).countItems().saveAsTextFile("#{collection_derivatives}/all-domains/output")
      RecordLoader.loadArchives("#{collection_warcs}", sc).keepValidPages().map(r => (r.getCrawlDate, r.getDomain, r.getUrl, RemoveHTML(r.getContentString))).saveAsTextFile("#{collection_derivatives}/all-text/output")
      val links = RecordLoader.loadArchives("#{collection_warcs}", sc).keepValidPages().map(r => (r.getCrawlDate, ExtractLinks(r.getUrl, r.getContentString))).flatMap(r => r._2.map(f => (r._1, ExtractDomain(f._1).replaceAll("^\\\\s*www\\\\.", ""), ExtractDomain(f._2).replaceAll("^\\\\s*www\\\\.", "")))).filter(r => r._2 != "" && r._3 != "").countItems().filter(r => r._2 > 5)
      WriteGEXF(links, "#{collection_derivatives}/gephi/#{c.collection_id}-gephi.gexf")
      sys.exit
      )
      File.open(collection_spark_job_file, 'w') { |file| file.write(spark_job) }
      spark_job_cmd = spark_shell + ' --master local[12] --driver-memory ' + spark_memory_driver + ' --conf spark.network.timeout=' + spark_network_timeout + ' --packages "io.archivesunleashed:aut:' + aut_version + '" -i ' + collection_spark_job_file + ' | tee ' + collection_spark_job_file + '.log'
      logger.info 'Executing: ' + spark_job_cmd
      system(spark_job_cmd)
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
