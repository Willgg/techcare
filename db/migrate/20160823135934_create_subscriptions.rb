class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.datetime :start_date
      t.references :user, index: true, foreign_key: true
      t.boolean :active
      t.integer :stripe_id

      t.timestamps null: false
    end
  end
end
