class CreateLocks < ActiveRecord::Migration[5.2]
  def change
    create_table :locks do |t|
      t.string :lock_name, null: false, :default => "New Lock"
      t.string :status , null: false, :default => "Unlocked"
      t.decimal :location
      t.string :group
      t.timestamps null: false

      t.belongs_to :user, index: true

      add_column :users, :phone, :integer


    end
  end
end
