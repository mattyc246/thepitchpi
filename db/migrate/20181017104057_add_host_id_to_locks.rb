class AddHostIdToLocks < ActiveRecord::Migration[5.2]
  def change
  	add_column :locks, :host_id, :string, null: false, :default => "123.245.1.1.6"
  end
end
