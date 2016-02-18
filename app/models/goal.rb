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
#  goal_value      :integer
#  end_date        :datetime
#  start_date      :datetime
#  end_value       :decimal(, )
#
# Indexes
#
#  index_goals_on_measure_type_id  (measure_type_id)
#  index_goals_on_user_id          (user_id)
#

class Goal < ActiveRecord::Base
  belongs_to :measure_type
  has_many :measures, through: :measure_type
  belongs_to :user
  belongs_to :adviser
  validates :measure_type_id, presence: true
  validates :user_id, presence: true
  validates :adviser_id, presence: true
  validates :goal_value, presence: true
  validates :end_date, presence: true
  validates :start_date, presence: true
  validates :title, presence: true, length: { in: 1..50 }
  validates :cumulative, inclusion: { in: [ true , false ]}

  def progression
    ratio = self.cumulative ? cumulative_progression : progression_for_user
    ratio > 1 ? 100 : (ratio * 100).round(2)
  end

  def last_measure_for_user(&block) #FIXME: should return a Measure object instead of value
    query = self.measures.where(user_id: self.user_id)
    query = block.call(query) if block_given?
    query.order(date: :asc).last.value
    #FIXME : what if 2 measures from different provider for the same day ?
    # goal.measure_type.measures.where(user_id: @user, measure_type_id: self.measure_type_id).order(date: :asc).last.value
  end

  def sum_of_measures
    @sum_of_measures  ||= self.measures.where(user: self.user, date: self.start_date..self.end_date).sum("value").to_i
  end

  def cumulative_progression
    sum_of_measures.to_f / self.goal_value.to_f
  end

  def progression_for_user
    origin_measure  = self.last_measure_for_user { |m| m.where("date < ?", self.start_date) }
    origin_measure  = origin_measure.to_f
    last_measure    = self.last_measure_for_user.to_f
    goal_value      = self.goal_value.to_f
    # Objectif est diminution
    if origin_measure > goal_value
      # Si progression est negative
      if last_measure >= origin_measure
        ratio = 0
      else
        ratio = (origin_measure - last_measure) / (origin_measure - goal_value)
      end
    # Objectif est augmentation
    elsif origin_measure < goal_value
      # Si progression est negative
      if last_measure <= origin_measure
        ratio = 0
      else
        ratio = (last_measure - origin_measure) / (goal_value - origin_measure)
      end
    else
        ratio = 1
    end
  end

  def is_running?
    self.end_date >= Time.current
  end

  def origin_measure
    self.last_measure_for_user { |m| m.where("date < ?", self.start_date) }
  end

  def is_increase?
    self.cumulative ? true : origin_measure.to_f < self.goal_value.to_f
  end

  def is_decrease?
    origin_measure.to_f > self.goal_value.to_f
  end

  def is_over?
    self.end_date < Time.current
  end

  def is_running?
    self.end_date >= Time.current
  end

  def is_achieved?
    # raise ArgumentError, "end_value must not be nil" if self.end_value.nil?
    end_value  = self.end_value || self.last_measure_for_user
    if self.is_increase?
      end_value >= self.goal_value
    elsif self.is_decrease?
      end_value <= self.goal_value
    else
      raise ArgumentError, 'Goal is neither an increase nor a decrease.'
    end
  end

  def is_succeed?
    return false unless self.is_over?
    self.is_achieved?
  end
end
