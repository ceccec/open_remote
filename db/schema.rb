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

ActiveRecord::Schema[8.1].define(version: 2026_01_28_075814) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "asset_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "display_name"
    t.string "icon"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_asset_types_on_name"
  end

  create_table "assets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "asset_type_id", null: false
    t.jsonb "attributes_data", default: {}
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.uuid "parent_id"
    t.datetime "updated_at", null: false
    t.index ["asset_type_id"], name: "index_assets_on_asset_type_id"
    t.index ["name"], name: "index_assets_on_name"
    t.index ["parent_id"], name: "index_assets_on_parent_id"
  end

  create_table "data_points", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "asset_id", null: false
    t.string "attribute_name", null: false
    t.datetime "created_at", null: false
    t.datetime "timestamp", null: false
    t.datetime "updated_at", null: false
    t.jsonb "value", null: false
    t.index ["asset_id", "attribute_name", "timestamp"], name: "index_data_points_on_asset_attr_time"
    t.index ["asset_id"], name: "index_data_points_on_asset_id"
    t.index ["timestamp"], name: "index_data_points_on_timestamp"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "acknowledged_at"
    t.uuid "asset_id"
    t.datetime "created_at", null: false
    t.text "message", null: false
    t.uuid "rule_id"
    t.datetime "sent_at", null: false
    t.string "severity", null: false
    t.datetime "updated_at", null: false
    t.index ["acknowledged_at"], name: "index_notifications_on_acknowledged_at"
    t.index ["asset_id"], name: "index_notifications_on_asset_id"
    t.index ["rule_id"], name: "index_notifications_on_rule_id"
    t.index ["sent_at"], name: "index_notifications_on_sent_at"
    t.index ["severity"], name: "index_notifications_on_severity"
  end

  create_table "rule_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error_message"
    t.datetime "executed_at", null: false
    t.jsonb "result", default: {}
    t.uuid "rule_id", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["executed_at"], name: "index_rule_executions_on_executed_at"
    t.index ["rule_id"], name: "index_rule_executions_on_rule_id"
    t.index ["status"], name: "index_rule_executions_on_status"
  end

  create_table "rules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "enabled", default: true, null: false
    t.string "name", null: false
    t.string "schedule"
    t.jsonb "then_config", default: {}
    t.string "timezone", default: "UTC"
    t.datetime "updated_at", null: false
    t.jsonb "when_config", default: {}
    t.index ["name"], name: "index_rules_on_name"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event", null: false
    t.uuid "item_id"
    t.string "item_type"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "updated_at", null: false
    t.uuid "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item"
    t.index ["whodunnit"], name: "index_versions_on_whodunnit"
  end

  add_foreign_key "assets", "asset_types"
  add_foreign_key "assets", "assets", column: "parent_id"
  add_foreign_key "data_points", "assets"
  add_foreign_key "notifications", "assets"
  add_foreign_key "notifications", "rules"
  add_foreign_key "rule_executions", "rules"
end
