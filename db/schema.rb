# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121202072606) do

  create_table "albums", :force => true do |t|
    t.string   "asin",         :null => false
    t.string   "category",     :null => false
    t.string   "name",         :null => false
    t.string   "artist",       :null => false
    t.string   "publisher"
    t.string   "image_path"
    t.text     "review"
    t.text     "tracks"
    t.date     "release_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "albums", ["artist"], :name => "index_albums_on_artist"
  add_index "albums", ["asin"], :name => "index_albums_on_asin", :unique => true

  create_table "rack_items", :force => true do |t|
    t.integer  "user_id",                 :null => false
    t.integer  "album_id",                :null => false
    t.text     "review"
    t.integer  "evaluation", :limit => 1
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rack_items", ["album_id"], :name => "index_rack_items_on_album_id"
  add_index "rack_items", ["user_id"], :name => "index_rack_items_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.date     "birthday"
    t.integer  "sex",                 :limit => 1, :null => false
    t.text     "profile"
    t.string   "image_path"
    t.integer  "twitter_id",          :limit => 8
    t.string   "mail_address"
    t.string   "password_digest"
    t.datetime "last_login_datetime"
    t.datetime "registered_datetime"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

end
