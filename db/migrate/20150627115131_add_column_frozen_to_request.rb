class AddColumnFrozenToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :is_frozen, :boolean, default: false
  end
end
