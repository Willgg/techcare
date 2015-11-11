class CreateMeasureTypes < ActiveRecord::Migration
  def change
    create_table :measure_types do |t|
      t.string :data_type
      t.string :unit
      t.string :name

      t.timestamps null: false
    end
  end
end
