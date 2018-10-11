class AddTrackingToLocks < ActiveRecord::Migration[5.2]
  def change
    add_column :locks, :tracking, :boolean, null: false, :default => false
    change_column :locks, :status, :string, null: false, :default => "Unlocked"
  end
end
