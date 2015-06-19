class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :confirmable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:twitter, :google_oauth2]


  has_many :requests, :foreign_key => :from
  extend FriendlyId

  friendly_id :twitter
  has_many :admirers, :foreign_key => :to, :class_name => "Request"
  before_create :auto_approve, :create_username

  has_many :conversations, :foreign_key => :sender_id
  scope :reverse, -> { order(created_at: :desc) }
  scope :timeline_users, -> (user) {
        joins(:requests).
        where("users.id != ?", user.id).
        group("users.id").
        merge(User.reverse)
  }


  # after_create :send_admin_mail

  # def send_admin_mail
  #   AdminMailer.new_user_waiting_for_approval(self).deliver
  # end

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
    self.provider.blank? && !confirmed?
  end


  private
  def auto_approve
    self.approved = true
  end

  def create_username
    self.twitter = email_username if self.provider != 'twitter'
  end

  def email_username
    self.email.split('@').first + self.uid.to_s
  end
end
