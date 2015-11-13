class AddStartDateToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :start_date, :datetime
  end
end
