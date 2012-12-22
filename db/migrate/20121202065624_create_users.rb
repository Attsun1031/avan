class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.date :birthday
      t.column :sex ,'tinyint unsigned not null'
      t.text :profile
      t.string :image_path
      t.column :twitter_id, 'bigint unsigned'
      t.string :mail_address
      t.string :password_digest
      t.datetime :last_login_datetime
      t.datetime :registered_datetime

      t.timestamps
    end
  end
end
