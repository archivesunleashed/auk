class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections, id: false, force: true do |t|
      t.integer :collection_id, null: false
      t.integer :user_id
      t.integer :account
      t.string :title
      t.boolean :public

      t.timestamps
    end
  end
end
