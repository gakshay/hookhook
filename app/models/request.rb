class Request < ActiveRecord::Base
  belongs_to :user, :foreign_key => :from
  belongs_to :wishlist


end
