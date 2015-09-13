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

ActiveRecord::Schema.define(version: 20150913221808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_messages", force: :cascade do |t|
    t.string   "token"
    t.text     "to"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "mailer"
    t.text     "subject"
    t.text     "content"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
  end

  add_index "ahoy_messages", ["token"], name: "index_ahoy_messages_on_token", using: :btree
  add_index "ahoy_messages", ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type", using: :btree

  create_table "invoicers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "invoicers", ["email"], name: "index_invoicers_on_email", unique: true, using: :btree
  add_index "invoicers", ["reset_password_token"], name: "index_invoicers_on_reset_password_token", unique: true, using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer  "minutes"
    t.integer  "rate"
    t.text     "notes"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "payee_id"
    t.integer  "invoicer_id"
  end

  add_index "invoices", ["invoicer_id"], name: "index_invoices_on_invoicer_id", using: :btree

  create_table "payees", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "invoicer_id"
  end

  add_index "payees", ["invoicer_id"], name: "index_payees_on_invoicer_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "invoice_id"
    t.string   "stripe_token"
    t.string   "auth_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "payments", ["invoice_id"], name: "index_payments_on_invoice_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "branding_html"
    t.boolean  "stripe_test_mode",            default: true
    t.string   "stripe_test_secret_key"
    t.string   "stripe_test_publishable_key"
    t.string   "stripe_live_secret_key"
    t.string   "stripe_live_publishable_key"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_foreign_key "payments", "invoices"
end
