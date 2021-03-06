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

ActiveRecord::Schema.define(version: 20141025212829) do

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "title",       default: 0
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["title"], name: "index_roles_on_title", unique: true, using: :btree

  create_table "user_role_powerdns_domains", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_role_powerdns_domains", ["user_id", "role_id", "domain_id"], name: "userroledomain_idx", unique: true, using: :btree

  create_table "user_role_powerdns_records", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "record_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_role_powerdns_records", ["user_id", "role_id", "record_id"], name: "userrecord_index", unique: true, using: :btree

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
