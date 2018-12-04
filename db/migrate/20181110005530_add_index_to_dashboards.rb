class AddIndexToDashboards < ActiveRecord::Migration[5.1]
  def change
    add_index :dashboards, [:job_id, :user_id, :collection_id, :queue, :start_time, :end_time], name: 'dashboard_index'
  end
end
