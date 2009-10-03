# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090926162545) do

  create_table "assignments", :force => true do |t|
    t.integer  "requirement_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_qualifications", :force => true do |t|
    t.integer "employee_id"
    t.integer "qualification_id"
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "initials",   :limit => 10
    t.date     "birthday"
    t.boolean  "active",                   :default => true
    t.string   "email"
    t.string   "phone"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qualifications", :force => true do |t|
    t.string "name"
    t.string "color", :limit => 6
  end

  create_table "requirements", :force => true do |t|
    t.integer  "shift_id"
    t.integer  "qualification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shifts", :force => true do |t|
    t.integer  "workplace_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workplace_qualifications", :force => true do |t|
    t.integer "workplace_id"
    t.integer "qualification_id"
  end

  create_table "workplace_requirements", :force => true do |t|
    t.integer  "workplace_id"
    t.integer  "qualification_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workplaces", :force => true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.string   "color",                :limit => 6
    t.integer  "default_shift_length"
    t.boolean  "active",                            :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
