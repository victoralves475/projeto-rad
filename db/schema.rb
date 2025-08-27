# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_27_004302) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "calculations", force: :cascade do |t|
    t.string "processo"
    t.string "crime"
    t.string "pena"
    t.date "start_date"
    t.integer "age"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "result"
    t.date "expires_on"
    t.index ["user_id", "created_at"], name: "index_calculations_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_calculations_on_user_id"
    t.check_constraint "age >= 18", name: "age_min_18"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.boolean "admin", default: false, null: false
    t.datetime "suspended_at"
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["suspended_at"], name: "index_users_on_suspended_at"
  end

  add_foreign_key "calculations", "users"
end
