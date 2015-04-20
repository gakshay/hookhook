class Request < ActiveRecord::Base
  belongs_to :user, :foreign_key => :from
  belongs_to :wishlist

  acts_as_taggable_on :pitch

  Tags =  [
      "one question please",
      "would love to learn from your experience",
      "need your opinion on something urgent",
      "in a critical situation, need help",
      "like to invite you for a coffee",
      "like to invite you for lunch or dinner",
      "less than 5 minutes of conversation"
  ]

  def for
    User.find(to)
  end

end
