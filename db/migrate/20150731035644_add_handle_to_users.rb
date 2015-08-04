class AddHandleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :handle, :string
    add_column :users, :handle_flag, :boolean, default: false
    add_index :users, :handle, unique: true
  end
end
