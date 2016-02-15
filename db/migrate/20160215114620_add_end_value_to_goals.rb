class AddEndValueToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :end_value, :decimal
  end
end
