class Request < ActiveRecord::Base
  belongs_to :user, :foreign_key => :from
  belongs_to :wishlist

  acts_as_taggable_on :pitch

  def for
    User.find(to)
  end

end
