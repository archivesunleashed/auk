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
    Dashboard.count + 1543
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

  def get_largest_collection
    largest_collection = WasapiFile.group(:collection_id)
                                   .sum(:size)
                                   .max_by { |_k, v| v }
    number_to_human_size(largest_collection[1])
  end

  def get_largest_collection_title
    largest_collection = WasapiFile.group(:collection_id)
                                   .sum(:size)
                                   .max_by { |_k, v| v }
    Collection.find(largest_collection[0]).title
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
end
