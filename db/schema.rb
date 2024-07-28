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

ActiveRecord::Schema[7.0].define(version: 2024_07_11_141646) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_teachers", force: :cascade do |t|
    t.integer "account_id"
    t.integer "teacher_id"
    t.boolean "admin"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["account_id"], name: "index_account_teachers_on_account_id"
    t.index ["teacher_id"], name: "index_account_teachers_on_teacher_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "phone"
    t.string "address"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "accounts_streams", id: false, force: :cascade do |t|
    t.integer "account_id"
    t.integer "stream_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  end

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

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.integer "account_id"
    t.integer "student_id"
    t.integer "paper_session_id"
    t.integer "question_id"
    t.string "answer"
    t.boolean "correct"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.float "score"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "batches", force: :cascade do |t|
    t.integer "account_id"
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "batches_exams", id: false, force: :cascade do |t|
    t.integer "batch_id"
    t.integer "exam_id"
  end

  create_table "batches_papers", id: false, force: :cascade do |t|
    t.integer "batch_id"
    t.integer "paper_id"
  end

  create_table "exam_sessions", force: :cascade do |t|
    t.integer "account_id"
    t.integer "exam_id"
    t.integer "student_id"
    t.integer "time_taken"
    t.float "max_marks"
    t.float "percentage"
    t.float "score"
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "exams", force: :cascade do |t|
    t.integer "account_id"
    t.string "name"
    t.integer "status"
    t.integer "duration"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "batch_id"
    t.index ["batch_id"], name: "index_exams_on_batch_id"
  end

  create_table "exams_segments", id: false, force: :cascade do |t|
    t.integer "exam_id"
    t.integer "segment_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "teacher_id"
    t.string "job_id"
    t.string "status"
    t.text "message"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_notifications_on_student_id"
    t.index ["teacher_id"], name: "index_notifications_on_teacher_id"
  end

  create_table "paper_sessions", force: :cascade do |t|
    t.integer "account_id"
    t.integer "paper_id"
    t.integer "student_id"
    t.integer "exam_session_id"
    t.integer "time_taken"
    t.float "max_marks"
    t.float "percentage"
    t.float "score"
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "exam_id"
    t.string "status"
    t.index ["exam_id"], name: "index_paper_sessions_on_exam_id"
  end

  create_table "papers", force: :cascade do |t|
    t.string "name"
    t.integer "account_id"
    t.integer "exam_id"
    t.integer "status"
    t.integer "duration"
    t.float "marks_per_question"
    t.float "negative_marks_per_question"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "no_of_questions"
  end

  create_table "papers_questions", id: false, force: :cascade do |t|
    t.integer "paper_id"
    t.integer "question_id"
  end

  create_table "papers_segments", id: false, force: :cascade do |t|
    t.integer "paper_id"
    t.integer "segment_id"
  end

  create_table "papers_topics", id: false, force: :cascade do |t|
    t.integer "paper_id"
    t.integer "topic_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "account_id"
    t.integer "topic_id"
    t.text "title"
    t.string "option1"
    t.string "option2"
    t.string "option3"
    t.string "option4"
    t.string "option5"
    t.string "answer"
    t.float "marks"
    t.float "negative_marks"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "segments", force: :cascade do |t|
    t.string "name"
    t.integer "account_id"
    t.boolean "match_all"
    t.integer "students_count"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "streams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "streams_subjects", id: false, force: :cascade do |t|
    t.integer "steam_id"
    t.integer "subject_id"
  end

  create_table "streams_teachers", id: false, force: :cascade do |t|
    t.integer "stream_id"
    t.integer "teacher_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "phone"
    t.string "address"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "subjects_teachers", id: false, force: :cascade do |t|
    t.integer "subject_id"
    t.integer "teacher_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "account_id"
    t.integer "batch_id"
    t.integer "student_id"
    t.string "roll_number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "phone"
    t.string "qualifications"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.integer "subject_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "notifications", "students"
  add_foreign_key "notifications", "teachers"
end
