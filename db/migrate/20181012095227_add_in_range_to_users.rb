class AddInRangeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :in_range, :boolean, null: false, :default => true
  end
end
