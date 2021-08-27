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

ActiveRecord::Schema.define(version: 2021_08_27_201359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balances", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "curr_id"
    t.float "bal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curr_id"], name: "index_balances_on_curr_id"
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "convs", force: :cascade do |t|
    t.bigint "curto_id"
    t.bigint "curfr_id"
    t.float "rel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curfr_id"], name: "index_convs_on_curfr_id"
    t.index ["curto_id"], name: "index_convs_on_curto_id"
  end

  create_table "currs", force: :cascade do |t|
    t.string "cod"
    t.string "desc"
    t.string "typ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trans", force: :cascade do |t|
    t.bigint "usrto_id"
    t.bigint "userfr_id"
    t.bigint "conv_id"
    t.float "bal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conv_id"], name: "index_trans_on_conv_id"
    t.index ["userfr_id"], name: "index_trans_on_userfr_id"
    t.index ["usrto_id"], name: "index_trans_on_usrto_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "firstname"
    t.string "lastname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "balances", "currs"
  add_foreign_key "balances", "users"
end
