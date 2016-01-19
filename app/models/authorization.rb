# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  source     :string
#  uid        :string
#  token      :string
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
  belongs_to :user

  validates :source, presence: true
  validates :token, :uniqueness => { :scope => :source,
    message: "token must be unique per source" }
end
