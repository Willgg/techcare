class CreateFoodPictures < ActiveRecord::Migration
  def change
    create_table :food_pictures do |t|
      t.references :measure, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
