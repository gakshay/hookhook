class Request < ActiveRecord::Base
  belongs_to :from_user, class: User, :foreign_key => :from
  belongs_to :to_user, class: User, :foreign_key => :to
  belongs_to :wishlist

  acts_as_taggable_on :looking_for

  before_save :make_hash_tags
  scope :genuine, -> { where('story is not null')}

  #TODO remove the following code from here... it belongs to helper
  Tags = {
      'A Question' => 'warning',
      'Learn' => 'info',
      'Urgent' => 'success',
      'Critical Help' => 'danger',
      'Coffee' => 'info',
      'Lunch' => 'warning',
      '5 Minutes' => 'success'
  }

  private
  def make_hash_tags
    self.looking_for_list = self.looking_for_list.map{|tag| tag.start_with?('#') ? tag.strip : '#'+(tag.strip)}
  end

end