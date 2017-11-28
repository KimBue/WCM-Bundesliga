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

ActiveRecord::Schema.define(version: 20171119175200) do

  create_table "goalgetters", force: :cascade do |t|
    t.integer "goalgetter_id"
    t.string "name"
    t.string "wikidata_id"
    t.integer "birthplace_id"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goals", id: false, force: :cascade do |t|
    t.integer "goal_id", null: false
    t.integer "goal_getter_id"
    t.string "goal_getter_name"
    t.boolean "is_overtime"
    t.boolean "is_own_goal"
    t.boolean "is_penalty"
    t.integer "match_minute"
    t.integer "score_team1"
    t.integer "score_team2"
    t.text "comment"
    t.integer "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_goals_on_goal_id", unique: true
    t.index ["match_id"], name: "index_goals_on_match_id"
  end

  create_table "groups", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "group_name"
    t.integer "group_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_groups_on_group_id", unique: true
  end

  create_table "league_goals", force: :cascade do |t|
    t.integer "league_id"
    t.string "goal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leagues", id: false, force: :cascade do |t|
    t.integer "league_id", null: false
    t.string "league_name"
    t.string "league_shortcut"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_leagues_on_league_id", unique: true
  end

  create_table "match_results", id: false, force: :cascade do |t|
    t.integer "result_id", null: false
    t.string "result_name"
    t.integer "points_team1"
    t.integer "points_team2"
    t.integer "result_order_id"
    t.integer "result_type_id"
    t.text "result_description"
    t.integer "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_results_on_match_id"
    t.index ["result_id"], name: "index_match_results_on_result_id", unique: true
  end

  create_table "matches", id: false, force: :cascade do |t|
    t.integer "match_id", null: false
    t.datetime "match_date_time"
    t.datetime "match_date_time_utc"
    t.datetime "last_update_date_time"
    t.boolean "match_is_finished"
    t.integer "location_id"
    t.string "location_city"
    t.string "location_stadium"
    t.integer "number_of_viewers"
    t.string "time_zone_id"
    t.integer "group_id"
    t.integer "league_id"
    t.integer "team1_id"
    t.integer "team2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_matches_on_group_id"
    t.index ["league_id"], name: "index_matches_on_league_id"
    t.index ["match_id"], name: "index_matches_on_match_id", unique: true
  end

  create_table "teams", id: false, force: :cascade do |t|
    t.integer "team_id", null: false
    t.string "team_name"
    t.string "short_name"
    t.string "team_icon_url"
    t.string "team_wikiId"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_teams_on_team_id", unique: true
  end

end
