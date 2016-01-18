class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :source
      t.string :uid
      t.string :key
      t.string :secret
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
