# frozen_string_literal: true

# Methods for Downloading Wasapi Files.
class WasapiFilesDownloadJob < ApplicationJob
  queue_as :default
  require 'open-uri'

  def perform(user_id, collection_id)
    wasapi_username = user_id.wasapi_username
    wasapi_password = user_id.wasapi_password
    download_files = WasapiFile.where('user_id = ? AND collection_id = ?',
                                      user_id, collection_id)
    Parallel.each(download_files, in_threads: 5) do |wasapi_file|
      download_path = ENV['DOWNLOAD_PATH'] +
                      '/' + wasapi_file.account.to_s +
                      '/' + wasapi_file.collection_id.to_s + '/' + 'warcs/'
      download_path_filename = download_path + wasapi_file.filename
      FileUtils.mkdir_p download_path
      download = open(wasapi_file.location_archive_it,
                      http_basic_authentication: [wasapi_username,
                                                  wasapi_password])
      IO.copy_stream(download, download_path_filename)
    end
  end
end
