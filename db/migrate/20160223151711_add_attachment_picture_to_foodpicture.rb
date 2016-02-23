class AddAttachmentPictureToFoodpicture < ActiveRecord::Migration
  def self.up
    change_table :food_pictures do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :food_pictures, :picture
  end
end
