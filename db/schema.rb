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

ActiveRecord::Schema.define(version: 20200519182158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "affiliate_code_purchases", force: :cascade do |t|
    t.bigint "affiliate_discount_code_id"
    t.float "affiliate_revenue", default: 0.0, null: false
    t.bigint "club_id"
    t.datetime "created_at", null: false
    t.float "discount", default: 0.0, null: false
    t.float "discounted_price", default: 0.0, null: false
    t.float "full_price", default: 0.0, null: false
    t.string "program_name", default: "", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["affiliate_discount_code_id"], name: "index_affiliate_code_purchases_on_affiliate_discount_code_id"
    t.index ["club_id"], name: "index_affiliate_code_purchases_on_club_id"
    t.index ["user_id"], name: "index_affiliate_code_purchases_on_user_id"
  end

  create_table "affiliate_discount_codes", force: :cascade do |t|
    t.integer "affiliation_rate", default: 0, null: false
    t.bigint "club_id"
    t.string "code", default: "code123", null: false
    t.string "contact_email", default: "", null: false
    t.string "contact_name", default: "", null: false
    t.datetime "created_at", null: false
    t.integer "discount", default: 0, null: false
    t.string "discount_type", default: "amount", null: false, comment: "accepted values: value or percent"
    t.date "end_date"
    t.integer "max_users", default: 1, null: false
    t.string "payment_info", default: "", null: false
    t.date "start_date"
    t.bigint "team_id"
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_affiliate_discount_codes_on_club_id"
    t.index ["team_id"], name: "index_affiliate_discount_codes_on_team_id"
  end

  create_table "affiliations", force: :cascade do |t|
    t.boolean "coach", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.integer "position"
    t.bigint "team_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["deleted_at"], name: "index_affiliations_on_deleted_at"
    t.index ["team_id"], name: "index_affiliations_on_team_id"
    t.index ["user_id"], name: "index_affiliations_on_user_id"
  end

  create_table "archieved_user_payments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "payment_name"
    t.float "payment_price"
    t.string "payment_stripe_id"
    t.bigint "single_payment_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["single_payment_id"], name: "index_archieved_user_payments_on_single_payment_id"
    t.index ["user_id"], name: "index_archieved_user_payments_on_user_id"
  end

  create_table "authentication_tokens", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "last_used_at"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_authentication_tokens_on_user_id"
  end

  create_table "club_affiliations", force: :cascade do |t|
    t.bigint "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["club_id"], name: "index_club_affiliations_on_club_id"
    t.index ["user_id"], name: "index_club_affiliations_on_user_id"
  end

  create_table "clubs", force: :cascade do |t|
    t.string "address_city"
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_state"
    t.string "address_zip"
    t.string "contact_email"
    t.string "contact_first_name"
    t.string "contact_last_name"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "logo"
    t.string "name"
    t.integer "position"
    t.string "slug"
    t.string "teams_csv"
    t.datetime "updated_at", null: false
    t.text "welcome_message"
    t.index ["deleted_at"], name: "index_clubs_on_deleted_at"
    t.index ["slug"], name: "index_clubs_on_slug", unique: true
  end

  create_table "confidence_ratings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "exercise_id"
    t.integer "rating", default: 0
    t.boolean "skipped", default: false, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "workout_id"
    t.index ["exercise_id"], name: "index_confidence_ratings_on_exercise_id"
    t.index ["user_id"], name: "index_confidence_ratings_on_user_id"
    t.index ["workout_id"], name: "index_confidence_ratings_on_workout_id"
  end

  create_table "data_migrations", id: :serial, force: :cascade do |t|
    t.string "version"
  end

  create_table "enrollments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "subscription_id"
    t.bigint "team_id"
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_enrollments_on_subscription_id"
    t.index ["team_id"], name: "index_enrollments_on_team_id"
  end

  create_table "exercise_workouts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "exercise_id"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.bigint "workout_id"
    t.index ["deleted_at"], name: "index_exercise_workouts_on_deleted_at"
    t.index ["exercise_id"], name: "index_exercise_workouts_on_exercise_id"
    t.index ["workout_id"], name: "index_exercise_workouts_on_workout_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.string "keyframe_content_type"
    t.string "keyframe_file_name"
    t.integer "keyframe_file_size"
    t.datetime "keyframe_updated_at"
    t.string "name"
    t.string "reps"
    t.string "rest"
    t.string "sets"
    t.datetime "updated_at", null: false
    t.string "video_content_type"
    t.string "video_file_name"
    t.integer "video_file_size"
    t.datetime "video_updated_at"
    t.index ["deleted_at"], name: "index_exercises_on_deleted_at"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.datetime "created_at"
    t.string "scope"
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "phase_attempts", force: :cascade do |t|
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "phase_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["phase_id"], name: "index_phase_attempts_on_phase_id"
    t.index ["user_id"], name: "index_phase_attempts_on_user_id"
  end

  create_table "phases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "keyframe_content_type"
    t.string "keyframe_file_name"
    t.integer "keyframe_file_size"
    t.datetime "keyframe_updated_at"
    t.string "name"
    t.integer "position"
    t.bigint "pyramid_module_id"
    t.boolean "supplemental", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "video_content_type"
    t.string "video_file_name"
    t.integer "video_file_size"
    t.datetime "video_updated_at"
    t.index ["deleted_at"], name: "index_phases_on_deleted_at"
    t.index ["pyramid_module_id"], name: "index_phases_on_pyramid_module_id"
  end

  create_table "pyramid_modules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.integer "display_track"
    t.string "icon_black"
    t.string "icon_white"
    t.string "keyframe_content_type"
    t.string "keyframe_file_name"
    t.integer "keyframe_file_size"
    t.datetime "keyframe_updated_at"
    t.integer "level"
    t.string "name"
    t.integer "position"
    t.text "prereq", default: [], array: true
    t.text "tracks", default: [], array: true
    t.datetime "updated_at", null: false
    t.string "video_content_type"
    t.string "video_file_name"
    t.integer "video_file_size"
    t.datetime "video_updated_at"
    t.index ["deleted_at"], name: "index_pyramid_modules_on_deleted_at"
  end

  create_table "pyramid_modules_single_payments", id: false, force: :cascade do |t|
    t.bigint "pyramid_module_id", null: false
    t.bigint "single_payment_id", null: false
  end

  create_table "single_payments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.float "price"
    t.integer "sort", default: 1
    t.string "special_label", default: ""
    t.text "specifications", default: ""
    t.string "string_id"
    t.string "thank_you_link"
    t.datetime "updated_at", null: false
  end

  create_table "snippets", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.integer "position"
    t.string "slug"
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "club_id"
    t.datetime "created_at", null: false
    t.date "end_date"
    t.json "metadata"
    t.decimal "price"
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["club_id"], name: "index_subscriptions_on_club_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "club_id"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "logo"
    t.string "name"
    t.integer "num_players"
    t.integer "position"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_teams_on_deleted_at"
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  create_table "temp_teams", force: :cascade do |t|
    t.bigint "club_id"
    t.string "coach_email"
    t.string "coach_first_name"
    t.string "coach_last_name"
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "num_players"
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_temp_teams_on_club_id"
  end

  create_table "unlocked_pyramid_modules", force: :cascade do |t|
    t.text "completed_phases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.integer "has_restriction", default: 0
    t.bigint "pyramid_module_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["pyramid_module_id"], name: "index_unlocked_pyramid_modules_on_pyramid_module_id"
    t.index ["user_id"], name: "index_unlocked_pyramid_modules_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.inet "current_sign_in_ip"
    t.datetime "deleted_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.datetime "invitation_accepted_at"
    t.datetime "invitation_created_at"
    t.integer "invitation_limit"
    t.datetime "invitation_sent_at"
    t.string "invitation_token"
    t.integer "invitations_count", default: 0
    t.bigint "invited_by_id"
    t.string "invited_by_type"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.inet "last_sign_in_ip"
    t.string "nickname"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "roles_mask"
    t.integer "sign_in_count", default: 0, null: false
    t.integer "single_payment_id"
    t.string "slug"
    t.string "stripe_customer_id"
    t.string "stripe_payment_id"
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "workouts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.bigint "phase_id"
    t.integer "position"
    t.boolean "supplemental", default: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_workouts_on_deleted_at"
    t.index ["phase_id"], name: "index_workouts_on_phase_id"
  end

  add_foreign_key "affiliate_code_purchases", "affiliate_discount_codes"
  add_foreign_key "affiliate_code_purchases", "clubs"
  add_foreign_key "affiliate_code_purchases", "users"
  add_foreign_key "affiliate_discount_codes", "clubs"
  add_foreign_key "affiliate_discount_codes", "teams"
  add_foreign_key "affiliations", "teams"
  add_foreign_key "affiliations", "users"
  add_foreign_key "archieved_user_payments", "users"
  add_foreign_key "authentication_tokens", "users"
  add_foreign_key "club_affiliations", "clubs"
  add_foreign_key "club_affiliations", "users"
  add_foreign_key "confidence_ratings", "exercises"
  add_foreign_key "confidence_ratings", "users"
  add_foreign_key "confidence_ratings", "workouts"
  add_foreign_key "enrollments", "subscriptions"
  add_foreign_key "enrollments", "teams"
  add_foreign_key "exercise_workouts", "exercises"
  add_foreign_key "exercise_workouts", "workouts"
  add_foreign_key "phase_attempts", "phases"
  add_foreign_key "phase_attempts", "users"
  add_foreign_key "phases", "pyramid_modules"
  add_foreign_key "subscriptions", "clubs"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "teams", "clubs"
  add_foreign_key "temp_teams", "clubs"
  add_foreign_key "unlocked_pyramid_modules", "pyramid_modules"
  add_foreign_key "unlocked_pyramid_modules", "users"
  add_foreign_key "workouts", "phases"
end
