class AddIndexToUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, [:uid, :email]
  end
end
