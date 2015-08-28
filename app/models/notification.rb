class Notification < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'

  scope :recent, -> { order(updated_at: :desc) }
  scope :unread, -> { where(read: false) }

  after_create :send_email

  private

  def send_email
    NotificationMailer.delay.new_notification_email(self) if self.recipient.email.present?
  end

end
