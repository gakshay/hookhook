class Subscriber < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i  }
  validates_presence_of :linkedin, if: :founding_user?
  validates_presence_of :blog, if: :founding_user?

  private

  def founding_user?
    self.founding
  end
end
