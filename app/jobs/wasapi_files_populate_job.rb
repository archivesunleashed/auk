# frozen_string_literal: true

# Methods for populating Wasapi Files.
class WasapiFilesPopulateJob < ApplicationJob
  queue_as :default

  # Constants
  WASAPI_BASE_URL = 'https://partner.archive-it.org/wasapi/v1/webdata'

  def perform(user)
    wasapi_request = HTTP.basic_auth(user: user.wasapi_username,
                                     pass: user.wasapi_password)
                         .get(WASAPI_BASE_URL)
    wasapi_results = JSON.parse(wasapi_request)
    wasapi_files = wasapi_results['files']
    wasapi_files.each do |file|
      WasapiFile.find_or_create_by(filename: file['filename']) do |wasapifile|
        wasapifile.filetype = file['filetype'],
        wasapifile.size = file['size'],
        wasapifile.filename = file['filename'],
        wasapifile.crawl_time = file['crawl-time'],
        wasapifile.crawl_start = file['crawl-start'],
        wasapifile.crawl = file['crawl'],
        wasapifile.account = file['account'],
        wasapifile.collection_id = file['collection'],
        wasapifile.location_archive_it = file['locations'][0],
        wasapifile.location_internet_archive = file['locations'][1],
        wasapifile.checksum_md5 = file['checksums']['md5'],
        wasapifile.checksum_sha1 = file['checksums']['sha1'],
        wasapifile.user_id = user.id
      end
    end
    paginate = wasapi_results['next']
    if paginate.present?
      loop do
        wasapi_paged_request = HTTP.basic_auth(user: user.wasapi_username,
                                               pass: user.wasapi_password)
                                   .get(paginate)
        wasapi_paged_results = JSON.parse(wasapi_paged_request)
        wasapi_paged_files = wasapi_paged_results['files']
        paginate = wasapi_paged_results['next']
        wasapi_paged_files.each do |file|
          WasapiFile.find_or_create_by(
            filename: file['filename']
          ) do |wasapifile|
            wasapifile.filetype = file['filetype'],
            wasapifile.size = file['size'],
            wasapifile.filename = file['filename'],
            wasapifile.crawl_time = file['crawl-time'],
            wasapifile.crawl_start = file['crawl-start'],
            wasapifile.crawl = file['crawl'],
            wasapifile.account = file['account'],
            wasapifile.collection_id = file['collection'],
            wasapifile.location_archive_it = file['locations'][0],
            wasapifile.location_internet_archive = file['locations'][1],
            wasapifile.checksum_md5 = file['checksums']['md5'],
            wasapifile.checksum_sha1 = file['checksums']['sha1'],
            wasapifile.user_id = user.id
          end
        end
        break if paginate.blank?
      end
    end
  end
end
