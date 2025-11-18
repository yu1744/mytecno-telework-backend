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

ActiveRecord::Schema[8.0].define(version: 2025_11_11_012843) do
  create_table "application_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "applications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date"
    t.float "work_hours"
    t.string "reason"
    t.bigint "application_status_id", null: false
    t.boolean "is_special_case"
    t.string "special_reason"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "work_option"
    t.boolean "is_special"
    t.boolean "is_overtime"
    t.time "overtime_end"
    t.string "overtime_reason"
    t.index ["application_status_id"], name: "index_applications_on_application_status_id"
    t.index ["user_id"], name: "index_applications_on_user_id"
  end

  create_table "approvals", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.string "comment"
    t.bigint "approver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending", null: false
    t.index ["application_id"], name: "index_approvals_on_application_id"
    t.index ["approver_id"], name: "index_approvals_on_approver_id"
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_groups_on_department_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "message"
    t.boolean "read", default: false
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transport_routes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_info_changes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "changer_id", null: false
    t.date "effective_date", null: false
    t.bigint "new_department_id"
    t.bigint "new_role_id"
    t.bigint "new_manager_id"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["changer_id"], name: "index_user_info_changes_on_changer_id"
    t.index ["new_department_id"], name: "index_user_info_changes_on_new_department_id"
    t.index ["new_manager_id"], name: "index_user_info_changes_on_new_manager_id"
    t.index ["new_role_id"], name: "index_user_info_changes_on_new_role_id"
    t.index ["user_id"], name: "index_user_info_changes_on_user_id"
  end

  create_table "user_transport_routes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "transport_route_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transport_route_id"], name: "index_user_transport_routes_on_transport_route_id"
    t.index ["user_id"], name: "index_user_transport_routes_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "email"
    t.date "hired_date"
    t.bigint "role_id", null: false
    t.bigint "department_id", null: false
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "manager_id"
    t.string "microsoft_access_token"
    t.string "microsoft_refresh_token"
    t.datetime "microsoft_token_expires_at"
    t.string "employee_number"
    t.bigint "group_id"
    t.string "position"
    t.boolean "is_caregiver"
    t.boolean "has_child_under_elementary"
    t.bigint "approver_id"
    t.index ["approver_id"], name: "index_users_on_approver_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["manager_id"], name: "index_users_on_manager_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "applications", "application_statuses"
  add_foreign_key "applications", "users"
  add_foreign_key "approvals", "applications"
  add_foreign_key "approvals", "users", column: "approver_id"
  add_foreign_key "groups", "departments"
  add_foreign_key "notifications", "users"
  add_foreign_key "user_info_changes", "departments", column: "new_department_id"
  add_foreign_key "user_info_changes", "roles", column: "new_role_id"
  add_foreign_key "user_info_changes", "users"
  add_foreign_key "user_info_changes", "users", column: "changer_id"
  add_foreign_key "user_info_changes", "users", column: "new_manager_id"
  add_foreign_key "user_transport_routes", "transport_routes"
  add_foreign_key "user_transport_routes", "users"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "groups"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "users", column: "approver_id"
  add_foreign_key "users", "users", column: "manager_id"
end
