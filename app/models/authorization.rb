# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  source     :string
#  uid        :string
#  key        :string
#  secret     :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_authorizations_on_user_id  (user_id)
#

class Authorization < ActiveRecord::Base
  belongs_to :user_id

  validates :source, presence: true
  validates :uid, presence: true
end
