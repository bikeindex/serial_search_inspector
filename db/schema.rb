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

ActiveRecord::Schema.define(version: 20161014163300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bikes", force: :cascade do |t|
    t.integer  "bike_index_id"
    t.boolean  "stolen"
    t.datetime "date_stolen"
    t.integer  "serial_search_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.boolean  "was_stolen"
    t.index ["serial_search_id"], name: "index_bikes_on_serial_search_id", using: :btree
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.text     "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "started_being_inspector_at"
    t.datetime "stopped_being_inspector_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "log_lines_count",            default: 0
    t.datetime "last_request_at"
    t.string   "name"
    t.text     "notes"
  end

  create_table "log_lines", force: :cascade do |t|
    t.json     "entry"
    t.datetime "request_at"
    t.string   "search_source"
    t.string   "search_type"
    t.boolean  "insufficient_length"
    t.boolean  "inspector_request"
    t.string   "entry_location"
    t.integer  "ip_address_id"
    t.integer  "serial_search_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["ip_address_id"], name: "index_log_lines_on_ip_address_id", using: :btree
    t.index ["serial_search_id"], name: "index_log_lines_on_serial_search_id", using: :btree
  end

  create_table "serial_searches", force: :cascade do |t|
    t.text     "serial"
    t.datetime "searched_bike_index_at"
    t.boolean  "too_many_results"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "last_request_at"
    t.integer  "log_lines_count",        default: 0
  end

end
