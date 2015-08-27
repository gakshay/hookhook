class Request < ActiveRecord::Base
  belongs_to :from_user, class: User, :foreign_key => :from
  belongs_to :to_user, class: User, :foreign_key => :to
  belongs_to :wishlist

  has_many :request_stats, dependent: :destroy
  scope :recently_updated, -> { order(updated_at: :desc)}
  scope :published, -> { where(published: true)}
  scope :unanswered, -> { where('reply IS NULL or reply = ?', '')}
  scope :answered, -> { where('reply IS NOT NULL and reply != ?', '')}

  validates_presence_of :story, :if => :published?

  PUBLISH_PERIOD_DAYS = 30

  acts_as_taggable_on :tags

  EMOTIONS = %w(#Mentoring #Referral #Feedback #Meeting #Q&A)

  before_save :make_hash_tags, :store_tags
  after_save :update_user_last_activity

  scope :genuine, -> { where('story is not null') }


  def published_until
    updated_at + PUBLISH_PERIOD_DAYS.days
  end

  def views
    request_stats.where(type: 'View')
  end

  def likes
    request_stats.where(type: 'Like')
  end

  def helps
    request_stats.where(type: 'Help')
  end

  private
  def make_hash_tags
    if self.emotion.present?
      stripped = self.emotion.strip
      if stripped.length > 0
        self.emotion = stripped.start_with?('#') ? stripped : '#'+(stripped)
      else
        self.emotion = nil
      end
    end
  end

  def store_tags
    if self.changes.include? :emotion
      self.tag_list = self.emotion
    end
  end

  def update_user_last_activity
    self.from_user.update_column(:last_activity_at, Time.now)
  end

end
