class CreateWishlists < ActiveRecord::Migration
  def change
    create_table :wishlists do |t|
      t.string :name
      t.string :description
      t.integer :status
      t.integer :limit
      t.timestamps null: false
    end
  end
end
