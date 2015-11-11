# == Schema Information
#
# Table name: advisers
#
#  id         :integer          not null, primary key
#  title      :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_advisers_on_user_id  (user_id)
#

class Adviser < ActiveRecord::Base
  belongs_to :user
  has_many :users
  validates :user_id, presence: true
  validates :title, presence: true
end
