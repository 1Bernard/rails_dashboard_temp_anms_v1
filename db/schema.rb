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

ActiveRecord::Schema[7.1].define(version: 2024_08_07_171427) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "auth_cycles", force: :cascade do |t|
    t.string "entity_code"
    t.integer "auth_user_id"
    t.string "auth_tracking_id"
    t.string "approval_status"
    t.text "comment"
    t.datetime "approved_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_requests", force: :cascade do |t|
    t.string "auth_tracking_id"
    t.boolean "authorized"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_users", force: :cascade do |t|
    t.string "entity_code"
    t.integer "auth_user_id"
    t.text "comment"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "callback_requests", force: :cascade do |t|
    t.text "message"
    t.string "trans_ref"
    t.string "trans_id"
    t.boolean "trans_status"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trans_msg"
  end

  create_table "entity_info_extras", force: :cascade do |t|
    t.string "entity_code"
    t.boolean "authorize_flag", default: false
    t.boolean "default_sms_flag", default: true
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_name_lookup", default: false
    t.string "sms_sender_id"
  end

  create_table "entity_infos", force: :cascade do |t|
    t.string "assigned_code"
    t.string "entity_name"
    t.string "email"
    t.string "contact_number"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entity_wallet_configs", force: :cascade do |t|
    t.string "entity_code"
    t.integer "entity_service_id"
    t.string "client_key"
    t.string "secret_key"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "error_logs", force: :cascade do |t|
    t.string "file_upload_id"
    t.string "entity_code"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "row_number"
    t.string "record_data"
  end

  create_table "file_uploads", force: :cascade do |t|
    t.string "entity_code"
    t.string "file_name"
    t.string "file_path"
    t.float "records"
    t.string "start_pan"
    t.string "end_pan"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference", limit: 25
  end

  create_table "payment_infos", force: :cascade do |t|
    t.string "entity_code"
    t.string "pan"
    t.string "nw"
    t.string "sort_code"
    t.float "amount"
    t.integer "file_upload_id"
    t.boolean "scheduled", default: false
    t.datetime "start_at", precision: nil
    t.text "msg_body"
    t.boolean "sent", default: false
    t.string "auth_tracking_id", limit: 255
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "receiver_name", limit: 255
    t.string "reference"
  end

  create_table "payment_requests", force: :cascade do |t|
    t.string "pan"
    t.string "nw"
    t.string "bank_code"
    t.boolean "processed"
    t.float "amount"
    t.string "trans_type"
    t.text "narration"
    t.integer "payment_info_id"
    t.integer "attempt"
    t.boolean "reprocessed"
    t.string "prev_processing_id"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "processing_id", limit: 255
  end

  create_table "permissions", force: :cascade do |t|
    t.string "subject_class"
    t.string "action"
    t.string "name"
    t.string "description"
    t.integer "user_id"
    t.boolean "active_status"
    t.boolean "del_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions_roles", force: :cascade do |t|
    t.integer "permission_id"
    t.integer "role_id"
    t.integer "user_id"
    t.string "role_code"
    t.string "mobile_number"
    t.boolean "active_status"
    t.boolean "del_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reprocess_trackers", force: :cascade do |t|
    t.string "orig_processing_id"
    t.string "prev_processing_id"
    t.string "reprocessing_id"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "unique_code"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.string "role_unique_code"
    t.string "entity_code"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username"
    t.string "lastname"
    t.string "other_names"
    t.string "mobile_number"
    t.boolean "active_status", default: true
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.boolean "del_status", default: false
    t.string "firstname"
    t.string "image_path"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
