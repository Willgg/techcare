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
#  api_provider           :string
#  api_consumer_key       :string
#  api_consumer_secret    :string
#  api_user_id            :string
#  height                 :integer
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
  SEXE = ["Male", "Female"]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sent_messages, foreign_key: "sender_id", class_name: "Message"
  has_many :received_messages, foreign_key: "recipient_id", class_name: "Message"
  has_many :goals, dependent: :nullify
  has_many :authorizations, dependent: :destroy
  has_many :measures, dependent: :destroy
  has_many :measure_types, through: :measures
  has_many :food_pictures, through: :measures
  has_one  :coach, class_name: "Adviser"
  has_one  :subscription, dependent: :nullify
  belongs_to :adviser

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :sexe, presence: true, inclusion: { in: SEXE }
  validates :birthday, presence: true
  validates :height, presence: true

  has_attached_file :picture,
    s3_protocol: :https,
    styles: { medium: "300x300#", thumb: "100x100#" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  after_commit :send_welcome_email, on: :create

  def messages
    sent_messages + received_messages
  end

  def full_name
    self.first_name + ' ' + self.last_name
  end

  def is_trainee?
    !self.is_adviser?
  end

  def notify_coach(coach)
    # Call method for different channel (emails, sms etc.)
    email_new_coach(coach)
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end

  def email_new_coach(coach)
    UserMailer.new_coach(self, coach).deliver_later
  end

end
