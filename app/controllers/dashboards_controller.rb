# frozen_string_literal: true

# Dashboard controller methods.
class DashboardsController < ApplicationController
  http_basic_authenticate_with name: ENV['DASHBOARD_USER'],
                               password: ENV['DASHBOARD_PASS']

  def index
    @dashboards = Dashboard.all.page params[:page]
  end

  def show; end

  private

  def dashboard_params
    params.require(:dashboard).permit(:job_id, :user_id, :collection_id,
                                      :queue, :start_time, :end_time)
  end
end
