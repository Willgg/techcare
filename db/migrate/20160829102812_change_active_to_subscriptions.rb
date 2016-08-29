class ChangeActiveToSubscriptions < ActiveRecord::Migration
  def change
    change_column :subscriptions, :active, :boolean, default: false
  end
end
