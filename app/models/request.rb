class Request < ActiveRecord::Base
  belongs_to :from_user, class: User, :foreign_key => :from
  belongs_to :to_user, class: User, :foreign_key => :to
  belongs_to :wishlist

  has_many :request_stats

  before_save :make_hash_tags
  scope :genuine, -> { where('story is not null') }
  scope :recently_updated, -> { order(updated_at: :desc)}

  def views
    request_stats.where(type: 'View')
  end

  def likes
    request_stats.where(type: 'Like')
  end

  private
  def make_hash_tags
    if self.purpose.present?
      stripped = self.purpose.strip
      if stripped.length > 0
        self.purpose = stripped.start_with?('#') ? stripped : '#'+(stripped)
      else
        self.purpose = nil
      end
    end
  end

end