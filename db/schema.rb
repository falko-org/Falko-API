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

ActiveRecord::Schema.define(version: 20171202210753) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "epics", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.integer "epic_id"
    t.index ["project_id"], name: "index_features_on_project_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "assignee"
    t.integer "milestone"
    t.string "labels"
    t.string "assignees"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "github_slug"
    t.boolean "is_project_from_github"
    t.boolean "is_scoring"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "releases", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "amount_of_sprints"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.date "initial_date"
    t.date "final_date"
    t.index ["project_id"], name: "index_releases_on_project_id"
  end

  create_table "retrospectives", force: :cascade do |t|
    t.text "sprint_report"
    t.text "positive_points", default: [], array: true
    t.text "negative_points", default: [], array: true
    t.text "improvements", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sprint_id"
    t.index ["sprint_id"], name: "index_retrospectives_on_sprint_id"
  end

  create_table "revisions", force: :cascade do |t|
    t.text "done_report", array: true
    t.text "undone_report", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sprint_id"
    t.index ["sprint_id"], name: "index_revisions_on_sprint_id"
  end

  create_table "sprints", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "release_id"
    t.date "initial_date"
    t.date "final_date"
    t.index ["release_id"], name: "index_sprints_on_release_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "assign"
    t.string "pipeline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sprint_id"
    t.date "initial_date"
    t.date "final_date"
    t.integer "story_points"
    t.string "issue_number"
    t.integer "feature_id"
    t.index ["sprint_id"], name: "index_stories_on_sprint_id"
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

  add_foreign_key "features", "projects"
  add_foreign_key "projects", "users"
  add_foreign_key "releases", "projects"
  add_foreign_key "retrospectives", "sprints"
  add_foreign_key "revisions", "sprints"
  add_foreign_key "sprints", "releases"
  add_foreign_key "stories", "sprints"
end
