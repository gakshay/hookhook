class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:twitter]
  has_many :requests, :foreign_key => :from

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email if auth.info.email
      user.encrypted_password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image = auth.info.image
      user.twitter = auth.info.nickname
      user.description = auth.info.description
    end
  end
end
