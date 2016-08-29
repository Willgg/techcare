class ChangeStripeIdToSubscriptions < ActiveRecord::Migration
  def change
    change_column :subscriptions, :stripe_id, :string
  end
end
