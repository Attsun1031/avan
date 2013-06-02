class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.references :user, :null => false
      t.references :product, :null => false
      t.boolean :checked, :null => false, :default => false
      t.text :comment

      t.timestamps
    end
    add_index :list_items, :user_id
    add_index :list_items, :product_id
  end
end
