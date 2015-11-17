class ChangeValueFromMeasures < ActiveRecord::Migration
  def change
    change_column :measures, :value, :decimal
  end
end
