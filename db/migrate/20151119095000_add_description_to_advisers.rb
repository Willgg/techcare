class AddDescriptionToAdvisers < ActiveRecord::Migration
  def change
    add_column :advisers, :description, :text
  end
end
