class Request < ActiveRecord::Base
  belongs_to :from_user, class: User, :foreign_key => :from
  belongs_to :to_user, class: User, :foreign_key => :to
  belongs_to :wishlist

  acts_as_taggable_on :pitch

  Tags =  [
      [ "one question please", "warning"],
      [ "would love to learn from your experience", "info"],
      ["need your opinion on something urgent", "success"],
      [ "in a critical situation need help", "danger"],
      [ "like to invite you for a coffee", "info"],
      [ "like to invite you for lunch or dinner", "warning"],
      [ "less than 5 minutes of conversation", "success"]
  ]

end