class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.references :check_list
      t.references :product
      t.boolean :checked
      t.text :comment
      t.string :image_path

      t.timestamps
    end
    add_index :list_items, :check_list_id
    add_index :list_items, :product_id
  end
end
