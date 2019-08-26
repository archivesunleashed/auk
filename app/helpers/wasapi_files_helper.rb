# frozen_string_literal: true

# WasapiFiles helper methods.
module WasapiFilesHelper
  def collection_count(collection_id, user_id)
    WasapiFile.where(collection_id: collection_id, user_id: user_id).count
  end

  def collection_size_human(collection_id, user_id)
    file_size = WasapiFile.where(collection_id: collection_id,
                                 user_id: user_id).sum(:size)
    number_to_human_size(file_size)
  end

  def collection_size(collection_id, user_id)
    WasapiFile.where(collection_id: collection_id,
                     user_id: user_id).sum(:size)
  end

  def disk_usage(user_id)
    account = WasapiFile.where(user_id: user_id).distinct.pluck(:account)
    if account.first.blank?
      return 0
    end

    if account.first.present?
      account_path = ENV['DOWNLOAD_PATH'] + '/' + account.first.to_s
      number_to_human_size(`du -sb "#{account_path}"`.split("\t").first.to_i)
    end
  end

  def collection_analyzed(collection_id, user_id)
    account = WasapiFile.where(user_id: user_id).distinct.pluck(:account)
    gexf = ENV['DOWNLOAD_PATH'] + '/' + account.first.to_s + '/' +
           collection_id.to_s + '/' + user_id.to_s + '/derivatives/gephi/' +
           collection_id.to_s + '-gephi.gexf'

    graphml = ENV['DOWNLOAD_PATH'] + '/' + account.first.to_s + '/' +
              collection_id.to_s + '/' + user_id.to_s + '/derivatives/gephi/' +
              collection_id.to_s + '-gephi.graphml'

    fulltext = ENV['DOWNLOAD_PATH'] + '/' + account.first.to_s + '/' +
               collection_id.to_s + '/' + user_id.to_s +
               '/derivatives/all-text/' + collection_id.to_s + '-fulltext.txt'

    domains = ENV['DOWNLOAD_PATH'] + '/' + account.first.to_s + '/' +
              collection_id.to_s + '/' + user_id.to_s +
              '/derivatives/all-domains/' + collection_id.to_s +
              '-fullurls.txt'
    if File.exist?(gexf) && !File.empty?(gexf) ||
       File.exist?(graphml) && !File.empty?(graphml) ||
       File.exist?(fulltext) && !File.empty?(fulltext) ||
       File.exist?(domains) && !File.empty?(domains) == true

      spark_log = ENV['DOWNLOAD_PATH'] + '/' + account.first.to_s + '/' +
                  collection_id.to_s + '/' + user_id.to_s + '/spark_jobs/' +
                  collection_id.to_s + '.scala.log'
      [File.mtime(spark_log).strftime('%B %-d, %Y'),
       File.mtime(spark_log).strftime('%Y%m%d')]
    end
  end
end
