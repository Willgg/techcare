class RemoveMeasureTypesIdFromMeasures < ActiveRecord::Migration
  def change
    remove_column :measures, :measure_types_id, :integer
  end
end
