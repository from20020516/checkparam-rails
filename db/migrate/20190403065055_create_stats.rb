class CreateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :stats, id: false do |t|
      t.column :item_id, 'INTEGER PRIMARY KEY NOT NULL'
      t.integer     :HP
      t.integer     :MP
      t.integer     :STR
      t.integer     :DEX
      t.integer     :VIT
      t.integer     :AGI
      t.integer     :INT
      t.integer     :MND
      t.integer     :CHR
      t.integer     :"Ｄ"
      t.integer     :"隔"
      t.integer     :"防"
      t.integer     :"命中"
      t.integer     :"飛命"
      t.integer     :"魔命"
      t.integer     :"攻"
      t.integer     :"飛攻"
      t.integer     :"魔攻"
      t.integer     :"回避"
      t.integer     :"魔回避"
      t.integer     :"魔防"
      t.integer     :"ヘイスト"
      t.integer     :"敵対心"
      t.integer     :"被ダメージ"
      t.integer     :"被物理ダメージ"
      t.integer     :"被魔法ダメージ"
      t.integer     :"ストアTP"
      t.integer     :"ファストキャスト"
      t.integer     :"精霊魔法の詠唱時間"
      t.integer     :"回復魔法の詠唱時間"
      t.integer     :"ケアル詠唱時間"
      t.integer     :"魔法ダメージ"
      t.integer     :"魔法剣ダメージ"
      t.integer     :"ファランクス"
      t.integer     :"マジックバーストダメージ"
      t.integer     :"マジックバーストダメージII"
      t.integer     :"二刀流"
      t.integer     :"ダブルアタック"
      t.integer     :"トリプルアタック"
      t.integer     :"クワッドアタック"
      t.integer     :"ダブルショット"
      t.integer     :"トリプルショット"
      t.integer     :"クワッドショット"
      t.integer     :"スナップショット"
      t.integer     :"ラピッドショット"
      t.integer     :"ウェポンスキルのダメージ"
      t.integer     :"ケアル回復量"
      t.integer     :"ケアル回復量II"
      t.integer     :"被ケアル回復量"
      t.integer     :"クリティカルヒット"
      t.integer     :"クリティカルヒットダメージ"
      t.timestamps
    end
  end
end
