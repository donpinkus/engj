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

ActiveRecord::Schema.define(version: 20150201204732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: true do |t|
    t.boolean  "hidden"
    t.boolean  "community_profile"
    t.string   "name"
    t.string   "angellist_url"
    t.string   "logo_url"
    t.string   "thumb_url"
    t.integer  "quality"
    t.text     "product_desc"
    t.text     "high_concept"
    t.integer  "follower_count"
    t.string   "company_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_url"
    t.string   "blog_url"
    t.string   "video_url"
  end

  create_table "job_skills", force: true do |t|
    t.integer  "job_id"
    t.text     "name"
    t.integer  "angel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_skills", ["job_id"], name: "index_job_skills_on_job_id", using: :btree

  create_table "jobs", force: true do |t|
    t.integer  "angel_id"
    t.text     "title"
    t.text     "description"
    t.datetime "listing_created_at"
    t.datetime "listing_updated_at"
    t.float    "equity_min"
    t.float    "equity_max"
    t.string   "currency_code"
    t.string   "job_type"
    t.integer  "salary_min",         limit: 8
    t.integer  "salary_max",         limit: 8
    t.string   "angellist_url"
    t.string   "location"
    t.string   "role"
    t.string   "company_name"
    t.integer  "company_id"
    t.string   "logo_url"
    t.text     "product_desc"
    t.text     "high_concept"
    t.string   "company_url"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
