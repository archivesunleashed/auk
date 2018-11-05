# frozen_string_literal: true

# Dashboard helper methods.
module DashboardsHelper
  def job_length(start_time, end_time)
    return if start_time.blank? || end_time.blank?
    TimeDifference.between(end_time, start_time).humanize
  end

  def get_username(user_id)
    user = User.find(user_id)
    username = user.auk_name
    if username.blank?
      user.name
    else
      user.auk_name
    end
  end

  def get_institution(user_id)
    User.find(user_id).institution
  end

  def get_collection_name(collection_id)
    Collection.find(collection_id).title
  end

  def get_total_number_of_jobs_run
    # 1543 is the number of jobs run before we implemented the Dashboard.
    Dashboard.where('end_time is not null').count + 1543
  end

  def get_number_of_users
    User.count
  end

  def get_most_jobs_user
    user_id = Dashboard.group(:user_id)
                       .select(:user_id)
                       .order('count(*) desc')
                       .first.user_id
    user = User.find(user_id)
    username = user.auk_name
    if username.blank?
      user.name
    else
      user.auk_name
    end
  end

  def get_most_jobs_user_institution
    user_id = Dashboard.group(:user_id)
                       .select(:user_id)
                       .order('count(*) desc')
                       .first.user_id
    user = User.find(user_id)
    user.institution
  end

  def get_largest_collection
    largest_collection = WasapiFile.group(:user_id)
                                   .group(:collection_id)
                                   .sum(:size)
                                   .max_by { |_k, v| v }
    number_to_human_size(largest_collection[1])
  end

  def get_largest_collection_title
    largest_collection = WasapiFile.group(:user_id)
                                   .group(:collection_id)
                                   .sum(:size)
                                   .max_by { |_k, v| v }
    Collection.find(largest_collection[0][1]).title
  end

  def get_total_number_of_warcs
    WasapiFile.distinct.count(:filename)
  end

  def get_total_number_of_collections
    Collection.distinct.count(:collection_id)
  end

  def get_space_used
    download_path = ENV['DOWNLOAD_PATH']
    number_to_human_size(`du -sb "#{download_path}"`.split("\t").first.to_i)
  end

  def get_space_available
    disk_space = Sys::Filesystem.stat(ENV['DOWNLOAD_PATH'])
    number_to_human_size(disk_space.block_size * disk_space.blocks_available)
  end

  def get_number_of_queued_jobs
    Delayed::Job.count
  end

  def seconds_to_str(seconds)
    ["#{seconds / 3600}h", "#{seconds / 60 % 60}m", "#{seconds % 60}s"]
      .select { |str| str =~ /[1-9]/ }.join(' ')
  end

  def get_total_job_time
    job_times = Dashboard.where('end_time is not null')
                         .pluck(:end_time, :start_time)
                         .map { |end_time, start_time|
                           { end_time: end_time, start_time: start_time }
                         }
    job_time = job_times.collect { |jt|
      TimeDifference.between(jt[:end_time], jt[:start_time]).in_seconds
    }
    total_time = job_time.inject(0) { |sum, x| sum + x }
    # 10973206.04 is the number of seconds job ran before we implemented the
    # Dashboard (extracted from Kibana).
    grand_total_time = (total_time + 10_973_206.04).round
    seconds_to_str(grand_total_time)
  end

  def get_longest_job_time
    job_times = Dashboard.where('end_time is not null')
                         .pluck(:end_time, :start_time)
                         .map { |end_time, start_time|
                           { end_time: end_time, start_time: start_time }
                         }
    job_time = job_times.collect { |jt|
      TimeDifference.between(jt[:end_time], jt[:start_time]).in_seconds
    }
    seconds_to_str(job_time.max.round)
  end

  def data_analyzed
    collection_and_user_ids = Dashboard.where(queue: 'cleanup')
                                       .pluck(:collection_id, :user_id)
                                       .map { |collection_id, user_id|
                                         { collection_id: collection_id,
                                           user_id: user_id }
                                       }
    total_data = collection_and_user_ids.collect { |collection_and_user_id|
      collection_size(collection_and_user_id[:collection_id],
                      collection_and_user_id[:user_id])
    }
    total_data_analyzed = total_data.inject(0) { |sum, x| sum + x }
    # 90_000_000_000_000 is the rough estimate of the total amount of data
    # analyzed before the dashboard was implemented.
    grand_total_data_analyzed = total_data_analyzed + 90_000_000_000_000
    number_to_human_size(grand_total_data_analyzed)
  end
end
