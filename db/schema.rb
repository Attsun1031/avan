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

ActiveRecord::Schema.define(:version => 20131014171505) do

  create_table "check_lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "check_lists", ["user_id", "name"], :name => "index_check_lists_on_user_id_and_name", :unique => true
  add_index "check_lists", ["user_id"], :name => "index_check_lists_on_user_id"

  create_table "list_items", :force => true do |t|
    t.integer  "check_list_id"
    t.integer  "product_id"
    t.boolean  "checked"
    t.text     "comment"
    t.string   "image_path"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "list_items", ["check_list_id", "product_id"], :name => "index_list_items_on_check_list_id_and_product_id", :unique => true
  add_index "list_items", ["product_id"], :name => "product_id"

  create_table "products", :force => true do |t|
    t.string   "asin",            :null => false
    t.string   "category"
    t.string   "creater_name"
    t.string   "image_url"
    t.string   "publisher"
    t.string   "title",           :null => false
    t.text     "item_attributes"
    t.string   "item_url",        :null => false
    t.date     "release_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "products", ["asin"], :name => "index_products_on_asin", :unique => true

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

  add_index "users", ["mail_address"], :name => "index_users_on_mail_address", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
