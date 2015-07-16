class AddColumnReplyToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :reply, :text
  end
end
