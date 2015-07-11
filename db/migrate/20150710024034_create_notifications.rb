class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.integer :recipient_id

      t.text :message
      t.boolean :read, default: false

      t.timestamps null: false
    end
    add_index :notifications, :sender_id
    add_index :notifications, :recipient_id

  end
end
