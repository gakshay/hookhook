class AddColumnMetBeforeToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :met_before, :boolean, :default => false
  end
end
