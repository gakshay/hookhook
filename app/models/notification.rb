class Notification < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'

  scope :recent, -> { order(updated_at: :desc) }
  scope :unread, -> { where(read: false) }

end
