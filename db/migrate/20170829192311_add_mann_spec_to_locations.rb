class AddMannSpecToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :mann_spec, :boolean
  end
end
