# frozen_string_literal: true

# WasapiFiles helper methods.
module WasapiFilesHelper
  def collection_count(collection_id, user_id)
    WasapiFile.where(collection_id: collection_id, user_id: user_id).count
  end

  def collection_size(collection_id, user_id)
    file_size = WasapiFile.where(collection_id: collection_id,
                                 user_id: user_id).sum(:size)
    number_to_human_size(file_size)
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
    analyzed = ENV['DOWNLOAD_PATH'] + '/' + account.first.to_s + '/' +
               collection_id.to_s + '/' + user_id.to_s + '/derivatives/gephi/' +
               collection_id.to_s + '-gephi.gexf'
    File.exist?(analyzed) && !File.empty?(analyzed)
  end
end
