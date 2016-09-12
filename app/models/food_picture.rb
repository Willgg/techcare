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

  validates :picture, presence: true

  has_attached_file :picture,
    s3_protocol: :https,
    styles: { large: "800x800#", medium: "300x300#", thumb: "150x150#" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  def user
    self.measure.user
  end
end
