class CreateRackItems < ActiveRecord::Migration
  def change
    create_table :rack_items do |t|
      t.references :user, :null => false
      t.references :album, :null => false
      t.text :review
      t.column :evaluation, "tinyint unsigned"

      t.timestamps
    end
    add_index :rack_items, :user_id
    add_index :rack_items, :album_id
  end
end
