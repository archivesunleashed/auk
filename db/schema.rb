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

ActiveRecord::Schema.define(version: 20180108203303) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "email"
    t.string "name"
    t.string "institution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "secret"
    t.string "encrypted_wasapi_username"
    t.string "encrypted_wasapi_password"
    t.string "encrypted_wasapi_username_iv"
    t.string "encrypted_wasapi_password_iv"
  end

  create_table "wasapi_files", force: :cascade do |t|
    t.string "checksum_md5"
    t.string "checksum_sha1"
    t.string "filetype"
    t.integer "size", limit: 8
    t.string "filename"
    t.string "crawl_time"
    t.string "crawl_start"
    t.integer "crawl"
    t.integer "account"
    t.integer "collection_id"
    t.string "location_archive_it"
    t.string "location_internet_archive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
