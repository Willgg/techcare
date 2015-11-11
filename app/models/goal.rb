# == Schema Information
#
# Table name: goals
#
#  id              :integer          not null, primary key
#  measure_type_id :integer
#  user_id         :integer
#  adviser_id      :integer
#  title           :string
#  cumulative      :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  end_value       :integer
#  end_date        :datetime
#
# Indexes
#
#  index_goals_on_measure_type_id  (measure_type_id)
#  index_goals_on_user_id          (user_id)
#

class Goal < ActiveRecord::Base
  belongs_to :measure_type
  belongs_to :user
  belongs_to :adviser
  validates :measure_type_id, presence: true
  validates :user_id, presence: true
  validates :adviser_id, presence: true
  validates :end_value, presence: true
  validates :end_date, presence: true
  validates :title, presence: true, length: { in: 1..50 }
  validates :cumulative, inclusion: { in: [ true , false ]}
end
