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

ActiveRecord::Schema.define(version: 2019_01_01_095010) do

  create_table "descriptions", force: :cascade do |t|
    t.text "ja"
    t.text "en"
    t.integer "Ｄ"
    t.integer "隔"
    t.integer "魔法ダメージ"
    t.integer "HP"
    t.integer "MP"
    t.integer "STR"
    t.integer "DEX"
    t.integer "VIT"
    t.integer "AGI"
    t.integer "INT"
    t.integer "MND"
    t.integer "CHR"
    t.integer "攻"
    t.integer "飛攻"
    t.integer "魔攻"
    t.integer "防"
    t.integer "魔防"
    t.integer "命中"
    t.integer "飛命"
    t.integer "魔命"
    t.integer "魔命スキル"
    t.integer "回避"
    t.integer "受け流しスキル"
    t.integer "魔回避"
    t.integer "被ダメージ"
    t.integer "被物理ダメージ"
    t.integer "被魔法ダメージ"
    t.integer "ダブルアタック"
    t.integer "トリプルアタック"
    t.integer "クワッドアタック"
    t.integer "クリティカルヒット"
    t.integer "クリティカルヒットダメージ"
    t.integer "ウェポンスキルのダメージ"
    t.integer "マジックバーストダメージ"
    t.integer "被クリティカルヒット"
    t.integer "ヘイスト"
    t.integer "二刀流"
    t.integer "ファストキャスト"
    t.integer "スナップショット"
    t.integer "ラピッドショット"
    t.integer "敵対心"
    t.integer "ストアTP"
    t.integer "モクシャ"
    t.integer "リジェネ"
    t.integer "リフレシュ"
    t.integer "コンサーブMP"
    t.integer "ケアル回復量"
    t.integer "ケアル回復量II"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipsets", force: :cascade do |t|
    t.text "main"
    t.text "sub"
    t.text "range"
    t.text "ammo"
    t.text "head"
    t.text "neck"
    t.text "ear1"
    t.text "ear2"
    t.text "body"
    t.text "hands"
    t.text "ring1"
    t.text "ring2"
    t.text "back"
    t.text "waist"
    t.text "legs"
    t.text "feet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "ja"
    t.string "en"
    t.integer "group"
    t.integer "slot"
    t.integer "skill"
    t.integer "job"
    t.integer "lv"
    t.integer "itemlv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.text "ja"
    t.text "en"
    t.text "ens"
    t.text "jas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.string "nickname"
    t.string "image"
    t.string "lang"
    t.integer "jobid"
    t.integer "setid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
