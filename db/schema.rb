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

ActiveRecord::Schema.define(:version => 20180218160942) do

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "salt"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "token"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inscription_players", :force => true do |t|
    t.integer  "inscription_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inscriptions", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "licence"
    t.string   "name"
    t.string   "email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.string   "secret"
  end

  create_table "keep_informeds", :force => true do |t|
    t.integer  "tournament_id"
    t.string   "email"
    t.boolean  "create_inscription"
    t.boolean  "unlicensened"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "play_series", :force => true do |t|
    t.integer  "inscription_player_id"
    t.integer  "series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "partner_id"
  end

  create_table "players", :force => true do |t|
    t.integer  "licence"
    t.string   "name"
    t.string   "first_name"
    t.string   "club"
    t.integer  "ranking"
    t.integer  "woman_ranking"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",      :default => "-"
    t.integer  "rank"
    t.integer  "woman_rank"
    t.string   "rv"
    t.string   "canton"
    t.integer  "elo"
  end

  create_table "quarks", :force => true do |t|
    t.string   "name"
    t.integer  "age"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", :force => true do |t|
    t.string   "series_name"
    t.string   "long_name"
    t.time     "start_time"
    t.integer  "min_ranking"
    t.integer  "max_ranking"
    t.string   "category"
    t.string   "sex"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_day_id", :default => 1
    t.integer  "use_rank"
    t.string   "type"
    t.integer  "min_elo"
    t.integer  "max_elo"
    t.integer  "slack_elo"
    t.integer  "slack_days"
    t.string   "sys_exp_link_de"
    t.string   "sys_exp_link_fr"
    t.string   "sys_exp_link_en"
    t.integer  "max_participants"
  end

  create_table "tournament_days", :force => true do |t|
    t.integer  "tournament_id"
    t.date     "day"
    t.integer  "max_inscriptions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "series_per_day"
    t.integer  "max_single_series"
    t.integer  "max_double_series"
    t.integer  "max_age_series"
    t.datetime "last_inscription_time"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "tour_id"
    t.string   "name"
    t.string   "date"
    t.string   "info_link"
    t.string   "organiser"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
    t.string   "stylesheet"
    t.string   "sender_email"
    t.string   "bcc_email"
    t.string   "facebook_link"
    t.string   "layout_parser"
    t.text     "favicon"
    t.datetime "last_inscription_time"
    t.boolean  "only_show_playable_series"
    t.string   "thanks_for_interest_en"
    t.string   "thanks_for_interest_de"
    t.string   "thanks_for_interest_fr"
    t.string   "remark_de",                 :limit => 3500
    t.string   "remark_fr",                 :limit => 3500
    t.string   "remark_en",                 :limit => 3500
    t.string   "salt"
    t.string   "hashed_api_key"
  end

  create_table "waiting_list_entries", :force => true do |t|
    t.integer  "tournament_day_id"
    t.integer  "inscription_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "waiting_list_series", :force => true do |t|
    t.integer  "waiting_list_entry_id"
    t.integer  "series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
