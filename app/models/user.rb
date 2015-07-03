class User < ActiveRecord::Base
  devise :database_authenticatable, :async, :registerable, :recoverable, :confirmable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:twitter, :google_oauth2]


  has_many :requests, :foreign_key => :from
  extend FriendlyId

  friendly_id :twitter
  has_many :admirers, :foreign_key => :to, :class_name => "Request"
  before_create :auto_approve, :create_username, :add_provider

  has_many :conversations, :foreign_key => :sender_id
  scope :reverse, -> { order(created_at: :desc) }
  scope :timeline_users, -> (user) {
        joins(:requests).
        where('users.id != ?', user.id).
        group('users.id HAVING count(requests.id) > 2').
        merge(User.reverse)
  }


  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def can_like?(req)
    self != req.to_user && self != req.from_user && req.request_stats.where(:user => self, type: 'Like').blank?
  end

  def can_freeze?(req)
    self == req.from_user && !req.is_frozen?
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email if auth.info.email
      user.name = auth.info.name
      user.image = auth.info.image
      user.twitter = auth.info.nickname if auth.provider == 'twitter'
      user.description = auth.info.description if auth.info.description
      user.twitter_verified = auth.info.verified   if auth.info.verified
      user.encrypted_password = Devise.friendly_token[0,20]
    end
    unless user.image == auth.info.image
      user.image = auth.info.image
      user.skip_confirmation!
      user.save!
    end
    user
  end

  def following?(user)
    requests.where(:to => user.id).present?
  end

  def original_image
    image.gsub('_normal', '') unless image.blank?
  end

  def original_400x400_image
    image.gsub('_normal', '_400x400') unless image.blank?
  end

  def email_provider?
    self.provider == "email"
  end

  # Below code checks if a user is approved or not by admin to use the platform

  # def active_for_authentication?
  #   super && approved?
  # end
  #
  # def inactive_message
  #   unless approved?
  #     :not_approved
  #   else
  #     super # Use whatever other message
  #   end
  # end

  protected

  def confirmation_required?
    (self.provider.blank? || self.email_provider?) && !confirmed?
  end


  def email_required?
    self.provider.blank? || self.email_provider?
  end

  def password_required?
    self.provider.blank? || self.email_provider? || !self.password.nil? || !self.password_confirmation.nil?
  end


  private

  def auto_approve
    self.approved = true
  end

  def add_provider
    self.provider = 'email' if self.email.present? && self.provider.blank? && self.password.present? && self.uid.blank?
  end

  def create_username
    self.twitter = email_username if self.provider != 'twitter'
  end

  def email_username
    self.email.split('@').first + self.uid.to_s
  end
end
