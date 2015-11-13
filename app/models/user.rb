# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  picture_file_name      :string
#  picture_content_type   :string
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  adviser_id             :integer
#  first_name             :string
#  last_name              :string
#  sexe                   :string
#  birthday               :datetime
#  is_adviser             :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_adviser_id            (adviser_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  SEXE = ["male", "female"]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sent_messages, foreign_key: "sender_id", class_name: "Message"
  has_many :received_messages, foreign_key: "recipient_id", class_name: "Message"

  has_many :measures
  has_many :goals
  has_many :measure_types, through: :measures
  has_one :coach, class_name: "Adviser"
  belongs_to :adviser
  validates :first_name, presence: true
  validates :sexe, presence: true, inclusion: { in: SEXE }
  validates :birthday, presence: true

  has_attached_file :picture,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  def messages
    sent_messages + received_messages
  end
end
