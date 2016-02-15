class ChangeEndValueFromGoals < ActiveRecord::Migration
  def change
    rename_column :goals, :end_value, :goal_value
  end
end
