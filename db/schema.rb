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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131002102640) do

  create_table "accounts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.integer  "owner_id"
    t.string   "slug"
  end

  add_index "accounts", ["owner_id"], :name => "index_accounts_on_owner_id"
  add_index "accounts", ["slug"], :name => "index_accounts_on_slug"

  create_table "blogs", :force => true do |t|
    t.integer  "organization_id"
    t.string   "title"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "blogs", ["organization_id"], :name => "index_blogs_on_organization_id"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.text     "body",             :default => ""
    t.integer  "employee_id",      :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["employee_id"], :name => "index_comments_on_employee_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "demands", :force => true do |t|
    t.integer  "quantity"
    t.integer  "qualification_id"
    t.integer  "shift_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "demands", ["qualification_id"], :name => "index_demands_on_qualification_id"
  add_index "demands", ["shift_id"], :name => "index_demands_on_shift_id"

  create_table "email_changes", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "token"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
  end

  add_index "email_changes", ["token"], :name => "index_email_changes_on_token"

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.decimal  "weekly_working_time"
    t.integer  "user_id"
    t.string   "role"
    t.string   "avatar"
    t.integer  "account_id"
    t.string   "shortcut",            :limit => 4
  end

  add_index "employees", ["account_id"], :name => "index_employees_on_account_id"
  add_index "employees", ["user_id"], :name => "index_employees_on_user_id"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "invitations", :force => true do |t|
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "accepted_at"
    t.integer  "inviter_id"
    t.integer  "organization_id"
    t.integer  "employee_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "email"
  end

  add_index "invitations", ["email"], :name => "index_invitations_on_email"
  add_index "invitations", ["employee_id"], :name => "index_invitations_on_employee_id"
  add_index "invitations", ["inviter_id"], :name => "index_invitations_on_inviter_id"
  add_index "invitations", ["organization_id"], :name => "index_invitations_on_organization_id"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "memberships", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "employee_id"
    t.decimal  "organization_weekly_working_time"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "role"
  end

  add_index "memberships", ["employee_id"], :name => "index_memberships_on_employee_id"
  add_index "memberships", ["organization_id"], :name => "index_memberships_on_organization_id"

  create_table "milestones", :force => true do |t|
    t.string   "name"
    t.integer  "plan_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "due_at"
    t.boolean  "done"
    t.integer  "responsible_id"
    t.text     "description"
  end

  add_index "milestones", ["responsible_id"], :name => "index_milestones_on_responsible_id"

  create_table "notifications", :force => true do |t|
    t.string   "type",            :null => false
    t.string   "notifiable_type"
    t.integer  "notifiable_id"
    t.integer  "employee_id",     :null => false
    t.datetime "sent_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "read_at"
  end

  add_index "notifications", ["employee_id"], :name => "index_notifications_on_employee_id"
  add_index "notifications", ["notifiable_id"], :name => "index_notifications_on_notifiable_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "account_id"
    t.string   "slug"
  end

  add_index "organizations", ["slug"], :name => "index_organizations_on_slug"

  create_table "plan_templates", :force => true do |t|
    t.string   "name"
    t.string   "template_type"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "plan_templates", ["organization_id"], :name => "index_plan_templates_on_organization_id"

  create_table "plans", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.text     "description"
    t.string   "slug"
  end

  add_index "plans", ["organization_id"], :name => "index_plans_on_organization_id"
  add_index "plans", ["slug"], :name => "index_plans_on_slug"

  create_table "posts", :force => true do |t|
    t.integer  "blog_id"
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.datetime "published_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "posts", ["author_id"], :name => "index_posts_on_author_id"
  add_index "posts", ["blog_id"], :name => "index_posts_on_blog_id"

  create_table "qualifications", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "account_id"
  end

  add_index "qualifications", ["account_id"], :name => "index_qualifications_on_account_id"

  create_table "schedulings", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "employee_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "team_id"
    t.integer  "next_day_id"
    t.integer  "qualification_id"
    t.integer  "comments_count",   :default => 0, :null => false
  end

  add_index "schedulings", ["employee_id"], :name => "index_schedulings_on_employee_id"
  add_index "schedulings", ["next_day_id"], :name => "index_schedulings_on_next_day_id"
  add_index "schedulings", ["plan_id"], :name => "index_schedulings_on_plan_id"
  add_index "schedulings", ["qualification_id"], :name => "index_schedulings_on_qualification_id"

  create_table "shifts", :force => true do |t|
    t.integer  "plan_template_id"
    t.time     "starts_at"
    t.time     "ends_at"
    t.integer  "team_id"
    t.integer  "next_day_id"
    t.integer  "day"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "shifts", ["next_day_id"], :name => "index_shifts_on_next_day_id"
  add_index "shifts", ["plan_template_id"], :name => "index_shifts_on_plan_template_id"
  add_index "shifts", ["team_id"], :name => "index_shifts_on_team_id"

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "milestone_id"
    t.datetime "due_at"
    t.boolean  "done"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "responsible_id"
    t.text     "description"
  end

  add_index "tasks", ["milestone_id"], :name => "index_tasks_on_milestone_id"
  add_index "tasks", ["responsible_id"], :name => "index_tasks_on_responsible_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organization_id"
    t.string   "shortcut"
    t.string   "color"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                       :default => "",   :null => false
    t.string   "encrypted_password",          :limit => 128,  :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                               :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                             :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.string   "roles",                       :limit => 1024
    t.string   "locale"
    t.string   "avatar"
    t.boolean  "receive_notification_emails",                 :default => true
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
