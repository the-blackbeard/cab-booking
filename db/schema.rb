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

ActiveRecord::Schema.define(version: 2020_05_19_133100) do

  create_table "cab_bookings", force: :cascade do |t|
    t.float "starting_lat", null: false
    t.float "starting_long", null: false
    t.float "ending_lat"
    t.float "ending_long"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "cab_id"
    t.index ["cab_id"], name: "index_cab_bookings_on_cab_id"
    t.index ["user_id"], name: "index_cab_bookings_on_user_id"
  end

  create_table "cabs", force: :cascade do |t|
    t.string "registration_number", null: false
    t.string "plate_number", null: false
    t.integer "status", null: false
    t.string "modelname"
    t.float "lat", null: false
    t.float "long", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_cabs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.integer "role", null: false
    t.float "long", null: false
    t.float "lat", null: false
  end

end
