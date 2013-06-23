class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :asin, :null => false, :unique => true
      t.string :category
      t.string :creater_name
      t.string :image_url
      t.string :publisher
      t.string :title, :null => false
      t.text :item_attributes
      t.string :item_url, :null => false

      t.timestamps
    end
    add_index :products, :asin
  end
end
