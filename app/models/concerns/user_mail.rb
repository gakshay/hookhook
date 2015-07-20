module UserMail
  extend ActiveSupport::Concern

  included do
    after_create :send_user_welcome_email
  end

  protected

  def send_user_welcome_email
    UserMailer.welcome_email(self).deliver unless self.email.blank?
  end

end