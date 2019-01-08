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
                         collection_id.to_s + '-fullurls.txt'
    unless File.zero?(collection_domains) || !File.file?(collection_domains)
      text = File.open(collection_domains).read
      csv_text = text.delete! '()'
      csv = CSV.parse(csv_text, headers: false)
      csv.take(10).each do |row|
      end
    end
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
      collection_id.to_s + '-fulltext.txt'
  end

  def domains_path(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    collection_path + user_id.to_s + '/derivatives/all-domains/' +
      collection_id.to_s + '-fullurls.txt'
  end
end
