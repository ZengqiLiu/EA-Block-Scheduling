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

ActiveRecord::Schema[7.2].define(version: 2025_05_07_211506) do
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

  create_table "block_courses", force: :cascade do |t|
    t.integer "block_selection_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_selection_id"], name: "index_block_courses_on_block_selection_id"
    t.index ["course_id"], name: "index_block_courses_on_course_id"
  end

  create_table "block_selections", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_block_selections_on_user_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blocks_courses", id: false, force: :cascade do |t|
    t.integer "block_id", null: false
    t.integer "course_id", null: false
    t.index ["block_id", "course_id"], name: "index_blocks_courses_on_block_id_and_course_id"
    t.index ["block_id"], name: "index_blocks_courses_on_block_id"
    t.index ["course_id", "block_id"], name: "index_blocks_courses_on_course_id_and_block_id"
    t.index ["course_id"], name: "index_blocks_courses_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "term"
    t.text "dept_code"
    t.string "course_id"
    t.string "sec_coreq_secs"
    t.string "syn"
    t.string "sec_name"
    t.string "short_title"
    t.integer "im"
    t.string "building"
    t.string "room"
    t.string "days"
    t.string "fac_id"
    t.string "faculty_name"
    t.integer "crs_capacity"
    t.integer "sec_cap"
    t.integer "student_count"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prerequisites"
    t.integer "as_id"
    t.string "corequisites"
    t.string "category"
    t.text "time_slots"
    t.index ["term", "dept_code", "syn", "sec_name"], name: "index_courses_on_unique_fields", unique: true
  end

  create_table "excel_files", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_role_accesses", force: :cascade do |t|
    t.integer "page_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string "url_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standalone_courses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_standalone_courses_on_course_id"
    t.index ["user_id"], name: "index_standalone_courses_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.string "uid"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "student_id"
    t.string "active"
    t.string "major"
    t.string "tamu_uid"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "block_courses", "block_selections"
  add_foreign_key "block_courses", "courses"
  add_foreign_key "block_selections", "users"
  add_foreign_key "standalone_courses", "courses"
  add_foreign_key "standalone_courses", "users"
end
