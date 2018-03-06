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
      csv.each do |row|
        row
      end
    end
  end

  def display_gexf(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    gexf_file = collection_path + user_id.to_s +
                '/derivatives/gephi/' + collection_id.to_s +
                '-gephi.gexf'
    render :plain => File.read(gexf_file).html_safe
  end

  def send_gexf

  end
end
