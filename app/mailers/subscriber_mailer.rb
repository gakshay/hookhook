class SubscriberMailer < MandrillMailer::TemplateMailer
  default from: "no-reply@request.to", from_name: "Request.to Team"

  def subscriber_email(subscriber)
    mandrill_mail template: 'subscriber-email',
                  to: subscriber.email,
                  vars: {
                      'CURRENT_YEAR' => Date.today.year,
                  },
                  important: true,
                  inline_css: true,
                  async: true
  end

  def founding_user_email(subscriber)
    mandrill_mail template: 'founding-user-email',
                  to: subscriber.email,
                  vars: {
                      'STORY' => subscriber.reason,
                      'CURRENT_YEAR' => Date.today.year,
                  },
                  important: true,
                  inline_css: true,
                  async: true
  end
end
