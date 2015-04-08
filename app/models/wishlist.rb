class Wishlist < ActiveRecord::Base
  STATUS = {
      0 => "Open",
      1 => "Closed"
  }
end
