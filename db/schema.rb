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

ActiveRecord::Schema.define(version: 2018_10_17_104057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locks", force: :cascade do |t|
    t.string "lock_name", default: "New Lock", null: false
    t.string "status", default: "Unlocked", null: false
    t.string "location"
    t.string "group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.float "longitude"
    t.float "latitude"
    t.boolean "tracking", default: false, null: false
    t.string "host_id", default: "123.245.1.1.6", null: false
    t.index ["user_id"], name: "index_locks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email", null: false
    t.boolean "subscription_status"
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.integer "phone"
    t.boolean "in_range", default: true, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

end
