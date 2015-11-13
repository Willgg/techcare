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

ActiveRecord::Schema.define(version: 20151112220130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advisers", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "advisers", ["user_id"], name: "index_advisers_on_user_id", using: :btree

  create_table "goals", force: :cascade do |t|
    t.integer  "measure_type_id"
    t.integer  "user_id"
    t.integer  "adviser_id"
    t.string   "title"
    t.boolean  "cumulative"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "end_value"
    t.datetime "end_date"
    t.datetime "start_date"
  end

  add_index "goals", ["measure_type_id"], name: "index_goals_on_measure_type_id", using: :btree
  add_index "goals", ["user_id"], name: "index_goals_on_user_id", using: :btree

  create_table "measure_types", force: :cascade do |t|
    t.string   "data_type"
    t.string   "unit"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measures", force: :cascade do |t|
    t.integer  "value"
    t.datetime "date"
    t.integer  "user_id"
    t.string   "source"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "measure_type_id"
  end

  add_index "measures", ["measure_type_id"], name: "index_measures_on_measure_type_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.datetime "read_at"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "adviser_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "sexe"
    t.datetime "birthday"
    t.boolean  "is_adviser",             default: false, null: false
  end

  add_index "users", ["adviser_id"], name: "index_users_on_adviser_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "advisers", "users"
  add_foreign_key "goals", "measure_types"
  add_foreign_key "goals", "users"
  add_foreign_key "measures", "measure_types"
  add_foreign_key "users", "advisers"
end
