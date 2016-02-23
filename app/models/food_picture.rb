# == Schema Information
#
# Table name: food_pictures
#
#  id                   :integer          not null, primary key
#  measure_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#
# Indexes
#
#  index_food_pictures_on_measure_id  (measure_id)
#

class FoodPicture < ActiveRecord::Base
  belongs_to :measure

  has_attached_file :picture,
    styles: { large: "1300x1300#", medium: "300x300#", thumb: "100x100#" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/
end
