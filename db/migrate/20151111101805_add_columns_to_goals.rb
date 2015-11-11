class AddColumnsToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :end_value, :integer
    add_column :goals, :end_date, :datetime
  end
end
