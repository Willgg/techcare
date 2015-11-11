class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.integer :value
      t.datetime :date
      t.integer :user_id
      t.string  :source
      t.integer :measure_types_id

      t.timestamps null: false
    end
  end
end
