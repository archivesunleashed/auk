class AddIndexToCollections < ActiveRecord::Migration[5.1]
  def change
    add_index :collections, [:account, :collection_id, :user_id, :title], name: 'collection_index'
  end
end
