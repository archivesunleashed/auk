class CreateDashboards < ActiveRecord::Migration[5.1]
  def change
    create_table :dashboards do |t|
      t.string :job_id
      t.integer :user_id
      t.integer :collection_id
      t.string :queue
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
