class SubscriberMailer < MandrillMailer::TemplateMailer
  default from: "piyush@request.to", from_name: "Piyush"

  def subscriber_email(subscriber)
    mandrill_mail template: 'early-user-acknowledgement-email',
                  to: subscriber.email,
                  vars: {
                      'CURRENT_YEAR' => Date.today.year,
                  },
                  important: true,
                  inline_css: true,
                  async: true
  end

  def founding_user_email(subscriber)
    mandrill_mail template: 'founding-user-acknowledgement-mail',
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
