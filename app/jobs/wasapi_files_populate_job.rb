# frozen_string_literal: true

# Methods for populating Wasapi Files.
class WasapiFilesPopulateJob < ApplicationJob
  queue_as :default

  # Constants
  WASAPI_BASE_URL = 'https://partner.archive-it.org/wasapi/v1/webdata'
  AI_COLLECTION_API_URL = 'https://partner.archive-it.org/api/collection/'

  def perform(user)
    wasapi_request = HTTP.basic_auth(user: user.wasapi_username,
                                     pass: user.wasapi_password)
                         .get(WASAPI_BASE_URL)
    wasapi_results = JSON.parse(wasapi_request)
    wasapi_files = wasapi_results['files']
    wasapi_files.each do |file|
      WasapiFile.find_or_create_by!(
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
          WasapiFile.find_or_create_by!(
            filename: file['filename'],
            filetype: file['filetype'],
            size: file['size'],
            crawl_time: file['crawl-time'],
            crawl_start: file['crawl-start'],
            crawl: file['crawl'],
            account: file['account'],
            collection_id: file['collection'],
            location_archive_it: file['locations'][0],
            location_internet_archive: file['locations'][1],
            checksum_md5: file['checksums']['md5'],
            checksum_sha1: file['checksums']['sha1'],
            user_id: user.id
          )
        end
        break if paginate.blank?
      end
    end
    WasapiFile.distinct.select('user_id, collection_id').each do |cid|
      collection_api_request_url = AI_COLLECTION_API_URL + cid.collection_id.to_s
      collection_api_request_code = HTTP.get(collection_api_request_url).code
      if collection_api_request_code == 200
        collection_api_request = HTTP.get(collection_api_request_url)
        collection_api_results = JSON.parse(collection_api_request)
        Collection.find_or_create_by!(
          collection_id: cid.collection_id,
          user_id: cid.user_id,
          title: collection_api_results['name'],
          public: collection_api_results['publicly_visible']
        )
      end
    end
  end
end
