class UserMailer < MandrillMailer::TemplateMailer
  default from: "piyush@request.to", from_name: "Piyush"

  def welcome_email(user)
    mandrill_mail template: 'new-user-welcome-email',
                  to: user.email,
                  vars: {
                      'CURRENT_YEAR' => Date.today.year,
                      'FNAME' => user.first_name,
                      'MYURL' => "#{HOSTNAME}/#{user.twitter}"
                  },
                  important: true,
                  inline_css: true,
                  async: true
  end
end
