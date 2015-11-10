class AddAdviserToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :adviser, index: true, foreign_key: true
  end
end
