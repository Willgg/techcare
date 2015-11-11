class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :sexe, :string
    add_column :users, :birthday, :datetime
    add_column :users, :is_adviser, :boolean, null: false, default: false
  end
end
