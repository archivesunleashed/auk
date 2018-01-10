class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections, id: false, force: true do |t|
      t.integer :collection_id, null: false
      t.string :title
      t.boolean :public
      t.text :description
      t.decimal :size
      t.integer :count

      t.timestamps
    end
  end
end
