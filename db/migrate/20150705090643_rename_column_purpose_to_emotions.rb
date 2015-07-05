class RenameColumnPurposeToEmotions < ActiveRecord::Migration
  def change
    rename_column :requests, :purpose, :emotion
  end
end
