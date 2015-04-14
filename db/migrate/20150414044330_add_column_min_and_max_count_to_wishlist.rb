class AddColumnMinAndMaxCountToWishlist < ActiveRecord::Migration
  def change
    add_column :wishlists, :min_count, :integer, :default => 3
    add_column :wishlists, :max_count, :integer, :default => 9
  end
end
