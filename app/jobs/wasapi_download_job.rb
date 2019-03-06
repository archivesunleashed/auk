# frozen_string_literal: true

# Methods for Downloading Wasapi Files.
class WasapiDownloadJob < ApplicationJob
  queue_as :download
  require 'open-uri'

  retry_on StandardError

  after_perform do |job|
    UserMailer.notify_collection_downloaded(job.arguments.first.id,
                                            job.arguments.second.id).deliver_now
    logger.info 'Email sent to: ' + job.arguments.first.email.to_s
    update_dashboard = Dashboard.find_by(job_id: job_id)
    update_dashboard.end_time = DateTime.now.utc
    update_dashboard.save
    if Rails.env.production?
      message = "Download of \"#{job.arguments.second.title}\" for #{job.arguments.first.auk_name} has finished."
      SLACK.ping message
    end
  end

  def perform(user_id, collection_id)
    Dashboard.find_or_create_by!(
      job_id: job_id,
      user_id: user_id.id.to_i,
      collection_id: collection_id.id.to_i,
      queue: 'download',
      start_time: DateTime.now.utc
    )
    wasapi_username = user_id.wasapi_username
    wasapi_password = user_id.wasapi_password
    download_files = WasapiFile.where('user_id = ? AND collection_id = ?',
                                      user_id, collection_id)
    Parallel.each(download_files, in_threads: 15) do |wasapi_file|
      download_path = ENV['DOWNLOAD_PATH'] +
                      '/' + wasapi_file.account.to_s +
                      '/' + wasapi_file.collection_id.to_s + '/' + 'warcs/'
      download_path_filename = download_path + wasapi_file.filename
      location_archive_it = wasapi_file.location_archive_it
      FileUtils.mkdir_p download_path
      if File.exist?(download_path_filename)
        check_file = Digest::MD5.file(download_path_filename).hexdigest
        if check_file == wasapi_file.checksum_md5
          logger.info 'File exists: ' + download_path_filename
        end
        if check_file != wasapi_file.checksum_md5
          logger.info 'Checksum mismatch:' + download_path_filename
          FileUtils.rm(download_path_filename)
          download_wasapi_file(location_archive_it, wasapi_username,
                               wasapi_password, download_path_filename)
        end
      end
      if !File.exist?(download_path_filename)
        download_wasapi_file(location_archive_it, wasapi_username,
                             wasapi_password, download_path_filename)
      end
    end
    SparkJob.set(queue: :spark)
            .perform_later(user_id.id, collection_id.id)
  end

  protected

  def download_wasapi_file(location_archive_it, wasapi_username,
                           wasapi_password, download_path_filename)
    logger.info 'Downloading: ' + location_archive_it
    download = open(location_archive_it,
                    http_basic_authentication: [wasapi_username,
                                                wasapi_password])
    IO.copy_stream(download, download_path_filename)
    logger.info 'Downloaded: ' + location_archive_it
  rescue
    logger.warn 'Download failed. Trying again: ' + location_archive_it
    retry
  end
end
