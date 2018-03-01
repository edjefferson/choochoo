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

ActiveRecord::Schema.define(version: 20180301174919) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "associations", force: :cascade do |t|
    t.string "transaction_type"
    t.string "base_uid"
    t.string "assoc_uid"
    t.date "assoc_start_date"
    t.date "assoc_end_date"
    t.string "assoc_days"
    t.string "assoc_cat"
    t.string "assoc_date_ind"
    t.string "assoc_location"
    t.string "base_location_suffix"
    t.string "assoc_location_suffix"
    t.string "diagram_type"
    t.string "association_type"
    t.string "filler"
    t.string "stp_indicator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "basic_schedule_extra_details", force: :cascade do |t|
    t.integer "basic_schedule_id"
    t.string "traction_class"
    t.string "uic_code"
    t.string "atoc_code"
    t.string "applicable_timetable_code"
    t.string "retail_train_id"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "basic_schedule_sequences", force: :cascade do |t|
    t.integer "basic_schedule_id"
    t.integer "origin_station_id"
    t.integer "origin_station_tiploc_id"
    t.text "origin_station_activity", default: [], array: true
    t.integer "intermediate_station_ids", default: [], array: true
    t.integer "intermediate_station_tiploc_ids", default: [], array: true
    t.text "intermediate_station_activities", default: [], array: true
    t.integer "terminating_station_id"
    t.integer "terminating_station_tiploc_id"
    t.text "terminating_station_activity", default: [], array: true
    t.integer "station_sequence_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "journey_length"
    t.index ["basic_schedule_id"], name: "index_basic_schedule_sequences_on_basic_schedule_id"
  end

  create_table "basic_schedules", force: :cascade do |t|
    t.string "transaction_type"
    t.string "train_uid"
    t.date "date_runs_from"
    t.date "date_runs_to"
    t.string "days_run"
    t.string "bank_holiday_running"
    t.string "train_status"
    t.string "train_category"
    t.string "train_identity"
    t.string "headcode"
    t.string "course_indicator"
    t.string "profit_centre_code"
    t.string "business_sector"
    t.string "power_type"
    t.string "timing_load"
    t.integer "speed"
    t.string "operating_chars"
    t.string "train_class"
    t.string "sleepers"
    t.string "reservations"
    t.string "connect_indicator"
    t.string "catering_code"
    t.string "service_branding"
    t.string "spare"
    t.string "stp_indicator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["train_uid"], name: "index_basic_schedules_on_train_uid"
  end

  create_table "change_en_routes", force: :cascade do |t|
    t.integer "intermediate_station_id"
    t.string "location"
    t.string "train_category"
    t.string "train_identity"
    t.string "headcode"
    t.string "course_indicator"
    t.string "profit_centre_code"
    t.string "business_sector"
    t.string "power_type"
    t.string "timing_load"
    t.integer "speed"
    t.string "operating_chars"
    t.string "train_class"
    t.string "sleepers"
    t.string "reservations"
    t.string "connect_indicator"
    t.string "catering_code"
    t.string "service_branding"
    t.string "traction_class"
    t.string "uic_code"
    t.string "retail_train_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "intermediate_stations", force: :cascade do |t|
    t.integer "basic_schedule_id"
    t.integer "tiploc_insert_id"
    t.string "location"
    t.string "scheduled_arrival_time"
    t.string "scheduled_departure_time"
    t.string "scheduled_pass"
    t.string "public_arrival"
    t.string "public_departure"
    t.string "platform"
    t.string "line"
    t.string "path"
    t.string "activity"
    t.string "engineering_allowance"
    t.string "pathing_allowance"
    t.string "performance_allowance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["basic_schedule_id"], name: "index_intermediate_stations_on_basic_schedule_id"
    t.index ["tiploc_insert_id"], name: "index_intermediate_stations_on_tiploc_insert_id"
  end

  create_table "origin_stations", force: :cascade do |t|
    t.integer "basic_schedule_id"
    t.integer "tiploc_insert_id"
    t.string "location"
    t.time "scheduled_departure_time"
    t.time "public_departure_time"
    t.string "platform"
    t.string "line"
    t.string "engineering_allowance"
    t.string "pathing_allowance"
    t.string "activity"
    t.string "performance_allowance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["basic_schedule_id"], name: "index_origin_stations_on_basic_schedule_id"
  end

  create_table "station_sequence_statistics", force: :cascade do |t|
    t.integer "station_sequence_id"
    t.string "sequence_type"
    t.integer "max_length"
    t.string "max_sequence_start"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "station_sequences", force: :cascade do |t|
    t.integer "tiploc_ids", default: [], array: true
    t.text "sequence", default: [], array: true
    t.integer "first_match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terminating_stations", force: :cascade do |t|
    t.integer "basic_schedule_id"
    t.integer "tiploc_insert_id"
    t.string "location"
    t.time "scheduled_arrival_time"
    t.time "public_arrival_time"
    t.string "platform"
    t.string "path"
    t.string "activity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["basic_schedule_id"], name: "index_terminating_stations_on_basic_schedule_id"
  end

  create_table "tiploc_inserts", force: :cascade do |t|
    t.string "tiploc"
    t.string "capitals"
    t.string "nalco"
    t.string "nlc_check"
    t.string "tps_description"
    t.string "stanox"
    t.string "po_mcp_code"
    t.string "crs_code"
    t.string "description"
    t.string "new_tiploc"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
