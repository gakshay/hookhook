class AddColumnPurposeToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :purpose, :string
  end
end
