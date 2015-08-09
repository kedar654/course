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

ActiveRecord::Schema.define(version: 20141023212241) do

  create_table "course_dates", force: true do |t|
    t.string   "start_date"
    t.string   "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_dates", ["start_date", "end_date"], name: "index_course_dates_on_start_date_and_end_date", unique: true

  create_table "courses", force: true do |t|
    t.integer  "course_id"
    t.string   "subject"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["course_id", "subject"], name: "index_courses_on_course_id_and_subject", unique: true

  create_table "instructors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instructors", ["first_name", "last_name"], name: "index_instructors_on_first_name_and_last_name", unique: true

  create_table "rooms", force: true do |t|
    t.string   "building"
    t.integer  "room_num"
    t.integer  "room_capacity"
    t.string   "desk_type"
    t.string   "board_type"
    t.string   "chair_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["building", "room_num"], name: "index_rooms_on_building_and_room_num", unique: true

  create_table "section_settings", force: true do |t|
    t.integer  "time_slot_id"
    t.integer  "instructor_id"
    t.integer  "room_id"
    t.integer  "course_date_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "section_settings", ["time_slot_id", "instructor_id", "room_id"], name: "section_setting_index", unique: true

  create_table "sections", force: true do |t|
    t.integer  "class_num"
    t.integer  "course_id"
    t.integer  "section_setting_id"
    t.integer  "sec_id"
    t.string   "sec_description"
    t.integer  "sec_capacity"
    t.string   "crsatr_val"
    t.string   "mode"
    t.string   "acad_group"
    t.string   "location"
    t.string   "component"
    t.string   "role"
    t.integer  "session"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["course_id", "sec_id", "section_setting_id"], name: "section_index", unique: true

  create_table "time_slots", force: true do |t|
    t.string   "days"
    t.string   "start_time"
    t.string   "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_slots", ["days", "start_time", "end_time"], name: "time_slot_index", unique: true

end
