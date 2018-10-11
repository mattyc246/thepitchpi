class AddLongitudeLatitudeToLocks < ActiveRecord::Migration[5.2]
  def change
    add_column :locks, :longitude, :float
    add_column :locks, :latitude, :float

    change_column :locks, :location, :string
  end
end
