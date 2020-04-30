# frozen_string_literal: true

# Collections helper methods.
module CollectionsHelper
  require 'csv'

  def display_domains(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    collection_domains = collection_path +
                         user_id.to_s + '/derivatives/all-domains/' +
                         collection_id.to_s + '-fullurls.csv'
    unless File.zero?(collection_domains) || !File.file?(collection_domains)
      text = File.open(collection_domains).read
      csv = CSV.parse(text, headers: false)
               .sort_by { |line| line[1].to_i }
               .reverse
      csv.take(10)
    end
  end

  def display_crawl_dates(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    crawl_dates = collection_path +
                  user_id.to_s +
                  '/derivatives/filtered-text/' +
                  collection_id.to_s +
                  '-crawl-date-count.csv'
    unless File.zero?(crawl_dates) || !File.file?(crawl_dates)
      text = File.open(crawl_dates).read
      csv = CSV.parse(text, headers: false)
      csv
    end
  end

  def crawl_date_path(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    collection_path + user_id.to_s + '/derivatives/filtered-text/' +
      collection_id.to_s + '-crawl-date-count.txt'
  end

  def textfilter_path(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    collection_derivatives = collection_path +
                             user_id.to_s + '/derivatives'
    collection_derivatives + '/filtered-text/' + collection_id.to_s +
      '-filtered_text.zip'
  end

  def gexf_path(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    collection_path + user_id.to_s + '/derivatives/gephi/' +
      collection_id.to_s + '-gephi.gexf'
  end

  def graphml_path(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    collection_path + user_id.to_s + '/derivatives/gephi/' +
      collection_id.to_s + '-gephi.graphml'
  end

  def fulltext_path(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    collection_path + user_id.to_s + '/derivatives/all-text/' +
      collection_id.to_s + '-fulltext.csv'
  end

  def domains_path(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    collection_path + user_id.to_s + '/derivatives/all-domains/' +
      collection_id.to_s + '-fullurls.csv'
  end
end
