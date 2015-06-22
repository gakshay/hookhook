class CreateRequestStats < ActiveRecord::Migration
  def change
    create_table :request_stats do |t|
      t.references :request, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :type

      t.timestamps null: false
    end
  end
end
