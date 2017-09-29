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

ActiveRecord::Schema.define(version: 20170928135913) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.datetime "login_at"
    t.string "first_name"
    t.string "last_name"
    t.string "first_name_ru"
    t.string "last_name_ru"
    t.string "first_name_en"
    t.string "last_name_en"
    t.integer "gender", limit: 2
    t.string "language"
    t.boolean "is_active", default: true
    t.datetime "sign_up_at"
    t.inet "sign_up_ip"
    t.string "sign_up_user_agent"
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "photo_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_comments_on_account_id"
    t.index ["photo_id"], name: "index_comments_on_photo_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "photo_id"
    t.boolean "up"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_likes_on_account_id"
    t.index ["photo_id"], name: "index_likes_on_photo_id"
  end

  create_table "passwords", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "views", default: 0
    t.integer "likes", default: 0
    t.integer "dislikes", default: 0
    t.integer "comments", default: 0
    t.integer "new_comments", default: 0
    t.binary "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_photos_on_account_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "account_id"
    t.string "session_key"
    t.string "user_agent"
    t.string "ip"
    t.integer "expire_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_sessions_on_account_id"
    t.index ["session_key"], name: "index_sessions_on_session_key", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "photo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_views_on_account_id"
    t.index ["photo_id"], name: "index_views_on_photo_id"
  end

  add_foreign_key "comments", "accounts"
  add_foreign_key "comments", "photos"
  add_foreign_key "likes", "accounts"
  add_foreign_key "likes", "photos"
  add_foreign_key "photos", "accounts"
  add_foreign_key "sessions", "accounts"
  add_foreign_key "views", "accounts"
  add_foreign_key "views", "photos"
end
