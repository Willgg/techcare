class ChangeKeyFromAuthorizations < ActiveRecord::Migration
  def change
    rename_column :authorizations, :key, :token
  end
end
