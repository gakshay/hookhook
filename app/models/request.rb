class Request < ActiveRecord::Base
  belongs_to :from_user, class: User, :foreign_key => :from
  belongs_to :to_user, class: User, :foreign_key => :to
  belongs_to :wishlist

  acts_as_taggable_on :pitch

  Tags =  [
      [ 'One question please', 'warning'],
      [ 'Would love to learn from your experience', 'info'],
      ['Need your opinion on something urgent', 'success'],
      [ 'In a critical situation need help', 'danger'],
      [ 'Like to invite you for a coffee', 'info'],
      [ 'Like to invite you for lunch or dinner', 'warning'],
      [ 'Less than 5 minutes of conversation', 'success']
  ]

end