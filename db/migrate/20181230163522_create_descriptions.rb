class CreateDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :descriptions do |t|
      t.text    :ja
      t.text    :en
      t.integer :"Ｄ"
      t.integer :"隔"
      t.integer :"魔法ダメージ"
      t.integer :HP
      t.integer :MP
      t.integer :STR
      t.integer :DEX
      t.integer :VIT
      t.integer :AGI
      t.integer :INT
      t.integer :MND
      t.integer :CHR
      t.integer :"攻"
      t.integer :"飛攻"
      t.integer :"魔攻"
      t.integer :"防"
      t.integer :"魔防"
      t.integer :"命中"
      t.integer :"飛命"
      t.integer :"魔命"
      t.integer :"魔命スキル"
      t.integer :"回避"
      t.integer :"受け流しスキル"
      t.integer :"魔回避"
      t.integer :"被ダメージ"
      t.integer :"被物理ダメージ"
      t.integer :"被魔法ダメージ"
      t.integer :"ダブルアタック"
      t.integer :"トリプルアタック"
      t.integer :"クワッドアタック"
      t.integer :"クリティカルヒット"
      t.integer :"クリティカルヒットダメージ"
      t.integer :"ウェポンスキルのダメージ"
      t.integer :"マジックバーストダメージ"
      t.integer :"被クリティカルヒット"
      t.integer :"ヘイスト"
      t.integer :"二刀流"
      t.integer :"ファストキャスト"
      t.integer :"スナップショット"
      t.integer :"ラピッドショット"
      t.integer :"敵対心"
      t.integer :"ストアTP"
      t.integer :"モクシャ"
      t.integer :"リジェネ"
      t.integer :"リフレシュ"
      t.integer :"コンサーブMP"
      t.integer :"ケアル回復量"
      t.integer :"ケアル回復量II"
      t.timestamps
    end
  end
end
