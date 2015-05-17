module SubscriberMail
  extend ActiveSupport::Concern

  included do
    after_create :send_subscriber_email, :unless => :founding?
    after_create :send_founding_user_email, :if => :founding?
  end

  protected

  def send_subscriber_email
    SubscriberMailer.subscriber_email(self).deliver
  end

  def send_founding_user_email
    SubscriberMailer.founding_user_email(self).deliver
  end
end