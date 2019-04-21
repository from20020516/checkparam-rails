class ChangeColumnDefaultsFromStats < ActiveRecord::Migration[5.2]
  def change
    change_column_default :stats, :HP, 0
    change_column_default :stats, :MP, 0
    change_column_default :stats, :STR, 0
    change_column_default :stats, :DEX, 0
    change_column_default :stats, :VIT, 0
    change_column_default :stats, :AGI, 0
    change_column_default :stats, :INT, 0
    change_column_default :stats, :MND, 0
    change_column_default :stats, :CHR, 0
    change_column_default :stats, :"Ｄ", 0
    change_column_default :stats, :"隔", 0
    change_column_default :stats, :"防", 0
    change_column_default :stats, :"命中", 0
    change_column_default :stats, :"飛命", 0
    change_column_default :stats, :"魔命", 0
    change_column_default :stats, :"攻", 0
    change_column_default :stats, :"飛攻", 0
    change_column_default :stats, :"魔攻", 0
    change_column_default :stats, :"回避", 0
    change_column_default :stats, :"魔回避", 0
    change_column_default :stats, :"魔防", 0
    change_column_default :stats, :"ヘイスト", 0
    change_column_default :stats, :"敵対心", 0
    change_column_default :stats, :"被ダメージ", 0
    change_column_default :stats, :"被物理ダメージ", 0
    change_column_default :stats, :"被魔法ダメージ", 0
    change_column_default :stats, :"ストアTP", 0
    change_column_default :stats, :"ファストキャスト", 0
    change_column_default :stats, :"精霊魔法の詠唱時間", 0
    change_column_default :stats, :"回復魔法の詠唱時間", 0
    change_column_default :stats, :"ケアル詠唱時間", 0
    change_column_default :stats, :"魔法ダメージ", 0
    change_column_default :stats, :"魔法剣ダメージ", 0
    change_column_default :stats, :"ファランクス", 0
    change_column_default :stats, :"マジックバーストダメージ", 0
    change_column_default :stats, :"マジックバーストダメージII", 0
    change_column_default :stats, :"二刀流", 0
    change_column_default :stats, :"ダブルアタック", 0
    change_column_default :stats, :"トリプルアタック", 0
    change_column_default :stats, :"クワッドアタック", 0
    change_column_default :stats, :"ダブルショット", 0
    change_column_default :stats, :"トリプルショット", 0
    change_column_default :stats, :"クワッドショット", 0
    change_column_default :stats, :"スナップショット", 0
    change_column_default :stats, :"ラピッドショット", 0
    change_column_default :stats, :"ウェポンスキルのダメージ", 0
    change_column_default :stats, :"ケアル回復量", 0
    change_column_default :stats, :"ケアル回復量II", 0
    change_column_default :stats, :"被ケアル回復量", 0
    change_column_default :stats, :"クリティカルヒット", 0
    change_column_default :stats, :"クリティカルヒットダメージ", 0
    change_column_default :stats, :"ペット_命中", 0
    change_column_default :stats, :"ペット_魔命", 0
    change_column_default :stats, :"ペット_攻", 0
    change_column_default :stats, :"ペット_魔攻", 0
    change_column_default :stats, :"ペット_ダブルアタック", 0
    change_column_default :stats, :"ペット_リジェネ", 0
    change_column_default :stats, :"ペット_被ダメージ", 0
    change_column_default :stats, :"ペット_被物理ダメージ", 0
    change_column_default :stats, :"ペット_被魔法ダメージ", 0
    change_column_default :stats, :"契約の履行使用間隔", 0
    change_column_default :stats, :"契約の履行使用間隔II", 0
    change_column_default :stats, :"ペット_契約の履行ダメージ", 0
    change_column_default :stats, :"召喚獣維持費", 0
    change_column_default :stats, :"詠唱中断率", 0
  end
end