class AddIndexToWasapiFiles < ActiveRecord::Migration[5.1]
  def change
    add_index :wasapi_files, [:user_id, :collection_id]
  end
end
