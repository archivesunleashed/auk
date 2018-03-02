# frozen_string_literal: true

# Collections helper methods.
module CollectionsHelper
  def display_domains(user_id, collection_id, account)
    collection_path = ENV['DOWNLOAD_PATH'] +
                      '/' + account.to_s +
                      '/' + collection_id.to_s + '/'
    collection_domains = collection_path +
                         user_id.to_s + '/derivatives/all-domains/' +
                         collection_id.to_s + '-fullurls.txt'
    if File.file?(collection_domains)
      text = File.open(collection_domains).read
      text.gsub!(/\r\n?/, "\n")
      text.delete! '()'
      text.each_line do |line|
        line
      end
    end
  end
end
