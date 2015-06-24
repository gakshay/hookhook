class CreateEligibilities < ActiveRecord::Migration
  def change
    create_table :eligibilities do |t|
      t.string :email
      t.string :designation
      t.string :explore
      t.text :interest
      t.text :priority
      t.string :meet

      t.timestamps null: false
    end
    add_index :eligibilities, :email, unique: true
  end
end
