class User < ActiveRecord::Base

  devise :database_authenticatable, :trackable, :recoverable, :rememberable#, :async, :registerable, :confirmable, :validatable
  devise :omniauthable, :omniauth_providers => [:twitter, :google_oauth2]

  include UserMail
  extend FriendlyId
  friendly_id :twitter

  validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i  }, allow_blank: true
  validates :handle, uniqueness: true, allow_blank: true

  has_many :requests, foreign_key: :from, dependent: :destroy
  has_many :admirers, foreign_key: :to, class_name: "Request", dependent: :destroy
  has_many :views, -> {where('type = ?', 'View')}, through: :admirers, source: :request_stats
  has_many :helps, -> {where('type = ?', 'Help')}, through: :admirers, source: :request_stats
  has_many :likes, -> {where('type = ?', 'Like')}, through: :admirers, source: :request_stats

  has_one :recent_request, -> {order 'updated_at desc'}, foreign_key: :from, class_name: "Request"
  has_many :conversations, foreign_key: :sender_id, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :messages, dependent: :destroy

  before_create :auto_approve, :create_username, :add_provider
  after_create :add_default_admirer

  scope :reverse, -> { order(last_activity_at: :desc) }
  scope :timeline_users, -> (user) {
        joins(:requests).
        where('users.id != ? and users.twitter != ?', user.id, 'Request_To').
        group('users.id HAVING count(requests.id) > 2').
        merge(User.reverse)
  }

  def username
    self.handle || self.twitter
  end

  def unanswered_requests(wish_list)
    requests.unanswered.where(:wishlist_id => wish_list.id)
  end

  def answered_requests(wish_list)
    requests.answered.where(:wishlist_id => wish_list.id)
  end

  def first_name
    self.name.try(:split, /\s+/).try(:first)
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def can_like?(req)
    self != req.to_user && self != req.from_user && req.request_stats.where(:user => self, type: 'Like').blank?
  end

  def can_reply?(req)
    self == req.to_user && req.reply.blank?
  end

  def can_help?(req)
    self != req.to_user && self != req.from_user && req.request_stats.where(:user => self, type: 'Help').blank?
  end

  def can_publish?(req)
    self == req.from_user && req.story.present? &&  req.emotion.present? && !req.published?
  end

  def can_modify?(req)
    self == req.from_user && !req.published?
  end

  def edit_published?(req)
    self == req.from_user && req.published?
  end

  #todo check this method.. looks like its not used or doesn't belong here
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth, params_email=nil)
    user = User.find_by_provider_and_uid(auth.provider, auth.uid)
    user = User.create do |user|
      user.email = params_email unless params_email.blank?
      user.email = auth.info.email if auth.info.email
      user.name = auth.info.name
      user.image = auth.info.image
      user.provider = auth.provider
      user.uid = auth.uid
      user.twitter = auth.info.nickname if auth.provider == 'twitter'
      user.description = auth.info.description if auth.info.description
      user.twitter_verified = auth.info.verified   if auth.info.verified
      user.encrypted_password = Devise.friendly_token[0,20]
    end  if user.blank?
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
    image.gsub('_normal', '') unless image.blank?
  end

  def original_400x400_image
    image.gsub('_normal', '_400x400') unless image.blank?
  end

  def email_provider?
    self.provider == "email"
  end


  def add_default_admirer
    user = User.find_by_twitter('Request_To')
    unless user.blank?
      story = "Warm welcome to Request.to and I hope that you will find it useful. If you have any feedback/ suggestion/ new ideas/ wild thoughts at any time, please shoot them to me at piyush@request.to. I'm all ears. We have pledged that we'll not rest unless you come back to us and say, 'wow'."
      self.admirers.create(from: user.id, wishlist_id: 1, emotion: '#Help', story: story, published: true)
    end
  end

  protected

  def confirmation_required?
    email_required? && !confirmed?
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
