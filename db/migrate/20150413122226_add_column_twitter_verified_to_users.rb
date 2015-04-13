class AddColumnTwitterVerifiedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_verified, :boolean
  end
end
