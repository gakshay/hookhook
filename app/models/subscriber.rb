class Subscriber < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i  }
  validates :name, presence: true
  validates_presence_of :twitter, if: :founding_user?

  include SubscriberMail

  private

  def founding_user?
    self.founding
  end
end
