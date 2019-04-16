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
      t.integer     :"ペット:命中"
      t.integer     :"ペット:魔命"
      t.integer     :"ペット:攻"
      t.integer     :"ペット:魔攻"
      t.integer     :"ペット:ダブルアタック"
      t.integer     :"ペット:リジェネ"
      t.integer     :"ペット:被ダメージ"
      t.integer     :"ペット:被物理ダメージ"
      t.integer     :"ペット:被魔法ダメージ"
      t.integer     :"契約の履行使用間隔"
      t.integer     :"契約の履行使用間隔II"
      t.integer     :"ペット:契約の履行ダメージ"
      t.integer     :"召喚獣維持費"
      t.integer     :"詠唱中断率"
      t.timestamps
    end
  end
end
