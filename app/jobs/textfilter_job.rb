# frozen_string_literal: true

# Methods for Basic Spark Jobs.
class TextfilterJob < ApplicationJob
  require 'csv'

  queue_as :textfilter

  after_perform do |job|
    UserMailer.notify_collection_analyzed(job.arguments.first,
                                          job.arguments.second).deliver_now
    CleanupJob.set(wait: 1.day).perform_later(job.arguments.first,
                                              job.arguments.second)
    update_dashboard = Dashboard.find_by(job_id: job_id)
    update_dashboard.end_time = DateTime.now.utc
    update_dashboard.save
    if Rails.env.production?
      user = User.find(job.arguments.first)
      collection = Collection.find(job.arguments.second)
      message = "Analysis of \"#{collection.title}\" for #{user.auk_name} has completed."
      SLACK.ping message
    end
  end

  def perform(user_id, collection_id)
    Dashboard.find_or_create_by!(
      job_id: job_id,
      user_id: user_id,
      collection_id: collection_id,
      queue: 'textfilter',
      start_time: DateTime.now.utc
    )
    Collection.where('user_id = ? AND collection_id = ?', user_id, collection_id).each do |c|
      collection_path = ENV['DOWNLOAD_PATH'] +
                        '/' + c.account.to_s +
                        '/' + c.collection_id.to_s + '/'
      collection_derivatives = collection_path + c.user_id.to_s + '/derivatives'
      collection_domains = collection_derivatives + '/all-domains/' +
                           c.collection_id.to_s + '-fullurls.csv'
      collection_fulltext = collection_derivatives + '/all-text/' +
                            c.collection_id.to_s + '-fulltext.csv'
      collection_filtered_text_path = collection_derivatives + '/filtered-text'
      FileUtils.mkdir_p collection_filtered_text_path
      unless File.zero?(collection_domains) || !File.file?(collection_domains)
        text = File.open(collection_domains).read
        csv = CSV.parse(text, headers: false)
        csv.take(10).each do |row|
          # THIS IS UGLY.
          # WE PROBABLY SHOULDN'T EXEC OUT TO GREP AND ZIP.
          domain_textfilter = collection_filtered_text_path + '/' +
                              collection_id.to_s + '-' + row[0].parameterize +
                              '.csv'
          interim_file = collection_filtered_text_path + '/' +
                         collection_id.to_s + '-' + row[0].parameterize +
                         '.tmp'
          grep_query = "'," + row[0] + ",'"
          grep_filter = '-a ' + grep_query + ' ' + collection_fulltext +
                        ' > ' + interim_file
          grep_binary_filter = '-vanPe \'^((?!.*$)|.*\0)\' ' + interim_file +
                               ' > ' + domain_textfilter
          `grep #{grep_filter}`
          `grep #{grep_binary_filter}`
        end
        filtered_text_zip = collection_filtered_text_path + '/' +
                            collection_id.to_s + '-filtered_text.zip'
        zip_command = '-j ' + filtered_text_zip + ' ' +
                      collection_filtered_text_path + '/*.csv'
        `zip #{zip_command}`
        `find #{collection_filtered_text_path} -type f -name '*.csv' -delete`
        `find #{collection_filtered_text_path} -type f -name '*.tmp' -delete`
      end
    end
  end
end
