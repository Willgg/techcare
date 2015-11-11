# == Schema Information
#
# Table name: measure_types
#
#  id         :integer          not null, primary key
#  data_type  :string
#  unit       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MeasureType < ActiveRecord::Base
  has_many :goals
  has_many :measures
  validates :unit, presence: true
  validates :name, presence: true
end
