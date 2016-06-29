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
  validates :title, length: { in: 1..50 }
  validates :cumulative, inclusion: { in: [ true , false ]}

  before_validation :dates_to_beginning_of_day, on: [:create,:update]
  before_validation :set_title, on: [:create, :update]

  def progression
    ratio = self.cumulative ? cumulative_progression : progression_for_user
    ratio > 1 ? 100 : (ratio * 100).round(2)
  end

  def last_measure_for_user(&block) #FIXME: should return a Measure object instead of value
    query = self.measures.where(user_id: self.user_id)
    query = block.call(query) if block_given?
    query.order(date: :asc).last.value
    #FIXME : what if 2 measures from different provider for the same day ?
  end

  def sum_of_measures
    @sum_of_measures  ||= self.measures.where(user: self.user, date: self.start_date..self.end_date).sum("value").to_i
  end

  def cumulative_progression
    current_value.to_f / self.goal_value.to_f
  end

  def progression_for_user
    origin_measure  = self.origin_measure.to_f
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
    end_value = self.end_value || current_value
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

  def current_value
    return self.end_value if self.end_value
    self.cumulative ? self.sum_of_measures : self.last_measure_for_user
  end

  def unit
    self.measure_type.unit
  end

  private

  def dates_to_beginning_of_day
    self.start_date = self.start_date.beginning_of_day
    self.end_date = self.end_date.beginning_of_day
  end

  def set_title
    self.title =
      case self.measure_type_id
        when 1
          'activerecord.goal.weight.set_title'
        when 2
          'activerecord.goal.blood_pressure.set_title'
        when 3
          'activerecord.goal.fat_ratio.set_title'
        when 4
          'activerecord.goal.steps.set_title'
      end
  end
end
