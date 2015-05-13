class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :email
      t.boolean :founding
      t.string :linkedin
      t.string :blog
      t.string :twitter
      t.text :reason
      t.text :hero
      t.timestamps null: false
    end
  end
end
