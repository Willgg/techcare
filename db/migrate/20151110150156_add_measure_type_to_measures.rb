class AddMeasureTypeToMeasures < ActiveRecord::Migration
  def change
    add_reference :measures, :measure_type, index: true, foreign_key: true
  end
end
