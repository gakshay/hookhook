class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:twitter]
  has_many :requests, :foreign_key => :from
  extend FriendlyId

  friendly_id :twitter
  has_many :admirers, :foreign_key => :to, :class_name => "Request"

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
      user.encrypted_password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image = auth.info.image
      user.twitter = auth.info.nickname
      user.description = auth.info.description
      user.twitter_verified = auth.info.verified
      user.approved = true #default
    end
    unless user.image == auth.info.image
      user.image = auth.info.image
      user.save!
    end
    user
  end

  def following?(user)
    requests.where(:to => user.id).present?
  end

  def original_image
    image.gsub('_normal', '')
  end

  def original_400x400_image
    image.gsub('_normal', '_400x400')
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

end
