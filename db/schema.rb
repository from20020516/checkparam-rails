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

ActiveRecord::Schema.define(version: 2019_04_20_190526) do

  create_table "gearsets", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "job_id", default: 1, null: false
    t.integer "set_id", default: 1, null: false
    t.integer "main"
    t.integer "sub"
    t.integer "range"
    t.integer "ammo"
    t.integer "head"
    t.integer "neck"
    t.integer "ear1"
    t.integer "ear2"
    t.integer "body"
    t.integer "hands"
    t.integer "ring1"
    t.integer "ring2"
    t.integer "back"
    t.integer "waist"
    t.integer "legs"
    t.integer "feet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "slot"
    t.integer "job"
    t.string "ja"
    t.string "en"
    t.text "description"
    t.integer "wiki_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "ja"
    t.string "en"
    t.string "ens"
    t.string "jas"
  end

  create_table "slots", force: :cascade do |t|
    t.integer "pos"
    t.string "en"
    t.integer "img"
  end

  create_table "stats", primary_key: "item_id", force: :cascade do |t|
    t.integer "HP"
    t.integer "MP"
    t.integer "STR"
    t.integer "DEX"
    t.integer "VIT"
    t.integer "AGI"
    t.integer "INT"
    t.integer "MND"
    t.integer "CHR"
    t.integer "Ｄ"
    t.integer "隔"
    t.integer "防"
    t.integer "命中"
    t.integer "飛命"
    t.integer "魔命"
    t.integer "攻"
    t.integer "飛攻"
    t.integer "魔攻"
    t.integer "回避"
    t.integer "魔回避"
    t.integer "魔防"
    t.integer "ヘイスト"
    t.integer "敵対心"
    t.integer "被ダメージ"
    t.integer "被物理ダメージ"
    t.integer "被魔法ダメージ"
    t.integer "ストアTP"
    t.integer "ファストキャスト"
    t.integer "精霊魔法の詠唱時間"
    t.integer "回復魔法の詠唱時間"
    t.integer "ケアル詠唱時間"
    t.integer "魔法ダメージ"
    t.integer "魔法剣ダメージ"
    t.integer "ファランクス"
    t.integer "マジックバーストダメージ"
    t.integer "マジックバーストダメージII"
    t.integer "二刀流"
    t.integer "ダブルアタック"
    t.integer "トリプルアタック"
    t.integer "クワッドアタック"
    t.integer "ダブルショット"
    t.integer "トリプルショット"
    t.integer "クワッドショット"
    t.integer "スナップショット"
    t.integer "ラピッドショット"
    t.integer "ウェポンスキルのダメージ"
    t.integer "ケアル回復量"
    t.integer "ケアル回復量II"
    t.integer "被ケアル回復量"
    t.integer "クリティカルヒット"
    t.integer "クリティカルヒットダメージ"
    t.integer "ペット_命中"
    t.integer "ペット_魔命"
    t.integer "ペット_攻"
    t.integer "ペット_魔攻"
    t.integer "ペット_ダブルアタック"
    t.integer "ペット_リジェネ"
    t.integer "ペット_被ダメージ"
    t.integer "ペット_被物理ダメージ"
    t.integer "ペット_被魔法ダメージ"
    t.integer "契約の履行使用間隔"
    t.integer "契約の履行使用間隔II"
    t.integer "ペット_契約の履行ダメージ"
    t.integer "召喚獣維持費"
    t.integer "詠唱中断率"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.string "lang", default: "ja"
    t.integer "job_id", default: 1
    t.integer "set_id", default: 1
    t.text "auth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wikis", force: :cascade do |t|
    t.text "ja"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
