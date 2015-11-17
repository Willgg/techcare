class AddApiToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_provider, :string
    add_column :users, :api_consumer_key, :string
    add_column :users, :api_consumer_secret, :string
    add_column :users, :api_user_id, :string
  end
end
