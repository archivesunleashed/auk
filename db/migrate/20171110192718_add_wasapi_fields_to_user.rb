class AddWasapiFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :encrypted_wasapi_username, :string
    add_column :users, :encrypted_wasapi_password, :string
    add_column :users, :encrypted_wasapi_username_iv, :string
    add_column :users, :encrypted_wasapi_password_iv, :string
  end
end
