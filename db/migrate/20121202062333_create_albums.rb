class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :asin, :null => false
      t.string :category, :null => false
      t.string :name, :null => false
      t.string :artist, :null => false
      t.string :publisher
      t.string :image_path
      t.text :review
      t.text :tracks
      t.date :release_date

      t.timestamps
    end
    add_index :albums, :asin, :unique => true
    add_index :albums, :artist
  end
end
