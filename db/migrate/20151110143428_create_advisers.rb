class CreateAdvisers < ActiveRecord::Migration
  def change
    create_table :advisers do |t|
      t.string :title
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
