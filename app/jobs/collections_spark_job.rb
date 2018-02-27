# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class CollectionsSparkJob < ApplicationJob
  queue_as :default
  require 'open-uri'

  def after_perform
    UserMailer.notify_collection_downloaded(something)
  end

  def perform(user_id, collection_id)
    spark_shell = ENV['SPARK_SHELL']
    WasapiFile.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      collection_path = ENV['DOWNLOAD_PATH'] +
                        '/' + c.account.to_s +
                        '/' + c.collection_id.to_s + '/'
      collection_warcs = collection_path + 'warcs/*.gz'
      collection_derivatives = collection_path + 'derivatives'
      collection_spark_jobs_path = collection_path + 'spark_jobs'
      collection_spark_job_file = collection_spark_jobs_path + '/' + c.collection_id.to_s + '.scala'
      FileUtils.mkdir_p collection_derivatives
      FileUtils.mkdir_p collection_spark_jobs_path
      spark_job = %(
      import io.archivesunleashed.spark.matchbox.{ExtractDomain, ExtractLinks, RemoveHTML, RecordLoader, WriteGEXF}
      import io.archivesunleashed.spark.rdd.RecordRDD._
      sc.setLogLevel("INFO")
      RecordLoader.loadArchives("#{collection_warcs}", sc).keepValidPages().map(r => ExtractDomain(r.getUrl)).countItems().saveAsTextFile("#{collection_derivatives}/all-domains")
      RecordLoader.loadArchives("#{collection_warcs}", sc).keepValidPages().map(r => (r.getCrawlDate, r.getDomain, r.getUrl, RemoveHTML(r.getContentString))).saveAsTextFile("#{collection_derivatives}/all-text")
      val links = RecordLoader.loadArchives("#{collection_warcs}", sc).keepValidPages().map(r => (r.getCrawlDate, ExtractLinks(r.getUrl, r.getContentString))).flatMap(r => r._2.map(f => (r._1, ExtractDomain(f._1).replaceAll("^\\\\s*www\\\\.", ""), ExtractDomain(f._2).replaceAll("^\\\\s*www\\\\.", "")))).filter(r => r._2 != "" && r._3 != "").countItems().filter(r => r._2 > 5)
      WriteGEXF(links, "#{collection_derivatives}/links-for-gephi.gexf")
      sys.exit
      )
      File.open(collection_spark_job_file, 'w') { |file| file.write(spark_job) }
      cmd = spark_shell + ' --master local[12] --driver-memory 5G --conf spark.network.timeout=10000000 --packages "io.archivesunleashed:aut:0.12.1" -i ' + collection_spark_job_file + ' | tee ' + collection_spark_job_file + '.log'
      logger.info '[INFO] Executing: ' + cmd
      system(cmd)
    end
  end
end
