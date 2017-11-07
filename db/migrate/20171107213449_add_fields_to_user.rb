class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token, :string
    add_column :users, :secret, :string
    add_column :users, :profile_image, :string
  end
end
