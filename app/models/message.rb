# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  content      :string
#  read_at      :datetime
#  sender_id    :integer
#  recipient_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Message < ActiveRecord::Base
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  validates :sender_id, presence: true
  validates :recipient_id, presence: true
  validates :content, presence: true, length: { in: 1..1000 }

  after_commit :send_new_message_email, on: :create

  def notify
    send_new_message_email
    send_new_message_sms
  end

  private

  def send_new_message_email
    MessageMailer.new_message(self).deliver_later
  end

  def send_new_message_sms
  end
end
