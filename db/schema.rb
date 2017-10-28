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

ActiveRecord::Schema.define(version: 20171028195641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "check_project"
  end

  create_table "releases", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "amount_of_sprints"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "initial_date"
    t.date "final_date"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_releases_on_project_id"
  end

  create_table "sprints", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "initial_date"
    t.date "final_date"
    t.bigint "release_id"
    t.index ["release_id"], name: "index_sprints_on_release_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "github"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_token"
  end

  add_foreign_key "releases", "projects"
  add_foreign_key "sprints", "releases"
end
