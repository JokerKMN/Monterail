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

ActiveRecord::Schema.define(version: 2021_01_24_015132) do

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.date "date", null: false
    t.time "time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "currency", default: "EUR", null: false
    t.integer "quantity_total", null: false
    t.integer "quantity_left", null: false
    t.integer "selling_option", null: false
    t.decimal "price", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_ticket_types_on_event_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "name", null: false
    t.integer "ticket_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_type_id"], name: "index_tickets_on_ticket_type_id"
  end

end
