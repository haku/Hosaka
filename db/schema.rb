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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141223204413) do

  create_table "columns", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.string   "column_hash", null: false
    t.string   "item_id"
    t.integer  "item_time",   null: false
    t.integer  "unread_time", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "columns", ["user_id", "column_hash"], name: "index_columns_on_user_id_and_column_hash", unique: true
  add_index "columns", ["user_id"], name: "index_columns_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "passwd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
