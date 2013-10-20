class CreateCheckLists < ActiveRecord::Migration
  def change
    create_table :check_lists do |t|
      t.references :user
      t.string :name

      t.timestamps
    end
    add_index :check_lists, :user_id
    add_index :check_lists, [:user_id, :name], :unique => true
  end
end
