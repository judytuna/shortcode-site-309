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

ActiveRecord::Schema.define(:version => 20111016232224) do

  create_table "contests", :force => true do |t|
    t.string   "title"
    t.integer  "charlimit"
    t.datetime "startdate"
    t.datetime "entrydeadline"
    t.datetime "votingstart"
    t.datetime "votingend"
    t.text     "rules"
    t.text     "ini"
    t.text     "thumbnailini"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.text     "shortcode"
    t.text     "longcode"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  add_index "entries", ["created_at"], :name => "index_entries_on_created_at"
  add_index "entries", ["user_id"], :name => "index_entries_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight"
  end

  add_index "votes", ["entry_id"], :name => "index_votes_on_entry_id"
  add_index "votes", ["user_id", "entry_id"], :name => "index_votes_on_user_id_and_entry_id", :unique => true
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
