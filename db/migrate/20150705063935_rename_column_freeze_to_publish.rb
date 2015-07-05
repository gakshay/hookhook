class RenameColumnFreezeToPublish < ActiveRecord::Migration
  def change
    rename_column :requests, :is_frozen, :published
  end
end
