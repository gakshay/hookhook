class AddTweetedColumnToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :tweeted, :boolean, default: false
  end
end
