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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140218012927) do

  create_table "urza_basictypes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urza_basictypes_cards", force: true do |t|
    t.integer "card_id"
    t.integer "basictype_id"
  end

  create_table "urza_card_names", force: true do |t|
    t.string   "name"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urza_card_variations", force: true do |t|
    t.integer  "card_id"
    t.integer  "variation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urza_cards", force: true do |t|
    t.string   "layout"
    t.string   "full_name"
    t.string   "mana_cost"
    t.float    "cmc"
    t.string   "card_type"
    t.string   "rarity"
    t.text     "text"
    t.text     "flavor_text"
    t.string   "artist"
    t.string   "number"
    t.string   "power"
    t.string   "toughness"
    t.integer  "loyalty"
    t.integer  "multiverse_id"
    t.string   "image_name"
    t.string   "watermark"
    t.string   "border"
    t.integer  "hand"
    t.integer  "life"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expansion_id"
    t.string   "fingerprint"
  end

  create_table "urza_cards_colors", force: true do |t|
    t.integer "card_id"
    t.integer "color_id"
  end

  create_table "urza_cards_subtypes", force: true do |t|
    t.integer "card_id"
    t.integer "subtype_id"
  end

  create_table "urza_cards_supertypes", force: true do |t|
    t.integer "card_id"
    t.integer "supertype_id"
  end

  create_table "urza_colors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urza_expansions", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.date     "release_date"
    t.string   "border"
    t.string   "set_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urza_subtypes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "urza_supertypes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
