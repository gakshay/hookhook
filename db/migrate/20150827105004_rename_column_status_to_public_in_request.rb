class RenameColumnStatusToPublicInRequest < ActiveRecord::Migration
  def change
    rename_column :requests, :status, :public
    change_column_default :requests, :public, false
  end
end
