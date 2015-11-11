class RemoveEndValueFromGoals < ActiveRecord::Migration

  def change
    remove_column :goals, :end_value, :datetime
  end
end
