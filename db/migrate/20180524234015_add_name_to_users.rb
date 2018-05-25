class AddNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :auk_name, :string
  end
end
