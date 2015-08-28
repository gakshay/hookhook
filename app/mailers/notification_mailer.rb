class NotificationMailer < ActionMailer::Base
  default from: 'piyush@request.to', from_name: 'Piyush'

  def new_notification_email(notification)
    @notification = notification
    mail(:to => notification.recipient.email, :subject => "#{notification.sender.name} #{notification.message}")
  end
end
