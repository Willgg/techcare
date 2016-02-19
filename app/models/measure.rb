# == Schema Information
#
# Table name: measures
#
#  id              :integer          not null, primary key
#  value           :decimal(, )
#  date            :datetime
#  user_id         :integer
#  source          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  measure_type_id :integer
#
# Indexes
#
#  index_measures_on_measure_type_id  (measure_type_id)
#

class Measure < ActiveRecord::Base
  belongs_to :user
  belongs_to :measure_type
  validates :user_id, presence: true
  validates :measure_type_id, presence: true
  validates :value, presence: true
  validates :date, presence: true

  def any_of_type?(measure_type)
    self.any? { |m| m.measure_type_id == measure_type.id }
  end
end
