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
    user = User.find(user_id)
    user.institution
  end

  def get_collection_name(collection_id)
    collection = Collection.find(collection_id)
    collection.title
  end
end
