class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :asin, :null => false
      t.string :title, :null => false
      t.string :creater_name
      t.string :publisher
      t.string :category
      t.string :image_path
      t.text :attribute

      t.timestamps
    end
    add_index :products, :asin
  end
end
