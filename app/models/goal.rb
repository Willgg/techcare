# == Schema Information
#
# Table name: goals
#
#  id              :integer          not null, primary key
#  measure_type_id :integer
#  user_id         :integer
#  adviser_id      :integer
#  end_value       :datetime
#  title           :string
#  cumulative      :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_goals_on_measure_type_id  (measure_type_id)
#  index_goals_on_user_id          (user_id)
#

class Goal < ActiveRecord::Base
  belongs_to :measure_type
  belongs_to :user
  validates :measure_type_id, presence: true
  validates :user_id, presence: true
  validates :adviser_id, presence: true
  validates :end_value, presence: true
  validates :end_time, presence: true
  validates :title, presence: true, length: { in: 1..10 }
  validates :cumulative, inclusion: { in: [ true , false ]}
end
