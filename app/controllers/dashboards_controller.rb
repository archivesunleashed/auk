# frozen_string_literal: true

# Dashboard controller methods.
class DashboardsController < ApplicationController
  http_basic_authenticate_with name: ENV['DASHBOARD_USER'],
                               password: ENV['DASHBOARD_PASS']
  include DashboardsHelper

  def index; end

  def graphs
    @dashboards = Dashboard.all
  end

  def jobs
    @dashboards = Dashboard.all.order('start_time DESC')
  end

  def stats
    @dashboards = Dashboard.all
  end

  def users_chart
    render json: User.group_by_day(:created_at).count
  end

  def jobs_chart
    render json: Dashboard.group(:queue)
                          .group_by_month(:created_at)
                          .count
                          .chart_json
  end

  def spark_throughput_chart
    queue_name = 'spark'
    render json: job_times(queue_name)
  end

  def download_throughput_chart
    queue_name = 'download'
    render json: job_times(queue_name).chart_json
  end

  def graphpass_throughput_chart
    queue_name = 'graphpass'
    render json: job_times(queue_name).chart_json
  end

  def textfilter_throughput_chart
    queue_name = 'textfilter'
    render json: job_times(queue_name).chart_json
  end

  def seed_throughput_chart
    queue_name = 'seed'
    render json: job_times(queue_name).chart_json
  end

  def cleanup_throughput_chart
    queue_name = 'cleanup'
    render json: job_times(queue_name).chart_json
  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:job_id, :user_id, :collection_id,
                                      :queue, :start_time, :end_time)
  end

  def job_times(queue_name)
    jt = Dashboard.where(queue: queue_name)
                  .where('end_time is not null')
                  .pluck(:end_time, :start_time, :id)

    jt.map { |k, v, i|
      Hash[i, TimeDifference.between(k, v).in_minutes]
    }.inject(:merge)
  end
end
