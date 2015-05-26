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

ActiveRecord::Schema.define(version: 20150317104504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "groups", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",                                    null: false
    t.string   "password_digest",                         null: false
    t.uuid     "user_id",                                 null: false
    t.decimal  "min_score",                 default: 0.0, null: false
    t.decimal  "max_score",                 default: 5.0, null: false
    t.decimal  "interval",                  default: 0.1, null: false
    t.decimal  "average_score",             default: 2.5, null: false
    t.integer  "exclude_score_after_weeks", default: 0,   null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree
  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "scores", force: :cascade do |t|
    t.uuid     "group_id",   null: false
    t.uuid     "user_id",    null: false
    t.decimal  "score",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "scores", ["group_id", "user_id"], name: "index_scores_on_group_id_and_user_id", unique: true, using: :btree
  add_index "scores", ["group_id"], name: "index_scores_on_group_id", using: :btree
  add_index "scores", ["user_id"], name: "index_scores_on_user_id", using: :btree

end
