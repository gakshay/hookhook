class Request < ActiveRecord::Base
  belongs_to :from_user, class: User, :foreign_key => :from
  belongs_to :to_user, class: User, :foreign_key => :to
  belongs_to :wishlist

  acts_as_taggable_on :pitch

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

  def req_pitch
    pitch_list[0]
  end

end