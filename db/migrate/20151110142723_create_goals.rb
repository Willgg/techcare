class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :measure_type, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :adviser_id
      t.integer :end_value
      t.datetime :end_value
      t.string :title
      t.boolean :cumulative

      t.timestamps null: false
    end
  end
end
