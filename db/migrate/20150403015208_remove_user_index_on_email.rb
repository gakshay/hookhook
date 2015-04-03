class RemoveUserIndexOnEmail < ActiveRecord::Migration
  def change
    remove_index :users, :email
    add_index :users, :twitter
  end
end
