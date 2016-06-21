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
  has_one    :food_picture, dependent: :destroy

  validates :user_id, presence: true
  validates :measure_type_id, presence: true
  validates :value, presence: true
  validates :date, presence: true
  validate :date_cannot_be_in_the_past, on: :update

  scope :weight, ->(order) { where(measure_type: 1).order(date: order) }
  scope :blood_pressure, ->(order) { where(measure_type: 2).order(date: order) }
  scope :fat_ratio, ->(order) { where(measure_type: 3).order(date: order) }
  scope :activities, ->(order) { where(measure_type: 4).order(date: order) }
  scope :food_pics_by, ->(order) { where(measure_type: 5).order(date: order) }

  def any_of_type?(measure_type)
    self.any? { |m| m.measure_type_id == measure_type.id }
  end

  def date_cannot_be_in_the_past
    if self.date > Time.current
      message = I18n.t('.activerecord.errors.models.measure.attributes.date.past')
      errors.add(:date, message)
    end
  end
end
