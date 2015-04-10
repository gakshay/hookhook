class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :from
      t.integer :to
      t.text :story
      t.boolean :status
      t.integer :wishlist_id

      t.timestamps null: false
    end
  end
end
