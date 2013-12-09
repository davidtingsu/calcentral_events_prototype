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

ActiveRecord::Schema.define(:version => 20131204034117) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "club_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "callink_id"
  end

  add_index "categories", ["callink_id"], :name => "index_categories_on_callink_id"
  add_index "categories", ["club_id"], :name => "index_categories_on_club_id"

  create_table "clubs", :force => true do |t|
    t.text     "description"
    t.text     "name"
    t.string   "facebook_id"
    t.integer  "category_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "facebook_url"
    t.string   "callink_id"
    t.string   "callink_permalink"
    t.string   "permalink"
  end

  add_index "clubs", ["callink_id"], :name => "index_clubs_on_callink_id"
  add_index "clubs", ["callink_permalink"], :name => "index_clubs_on_callink_permalink"
  add_index "clubs", ["category_id"], :name => "index_clubs_on_category_id"
  add_index "clubs", ["permalink"], :name => "index_clubs_on_permalink"

  create_table "events", :force => true do |t|
    t.text     "description"
    t.datetime "end_time"
    t.datetime "start_time"
    t.string   "facebook_id"
    t.integer  "club_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "name"
    t.string   "callink_id"
  end

  add_index "events", ["club_id"], :name => "index_events_on_club_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
