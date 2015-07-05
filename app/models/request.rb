class Request < ActiveRecord::Base
  belongs_to :from_user, class: User, :foreign_key => :from
  belongs_to :to_user, class: User, :foreign_key => :to
  belongs_to :wishlist

  has_many :request_stats
  scope :recently_updated, -> { order(updated_at: :desc)}


  PUBLISH_PERIOD_DAYS = 30

  EMOTIONS = %w(#Inspired #Appreciate #Respect #Support #ThankYou)

  before_save :make_hash_tags
  scope :genuine, -> { where('story is not null') }

  def frozen_until
    PUBLISH_PERIOD_DAYS - ((Time.now - updated_at).to_i / (24 * 60 * 60))
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

end
