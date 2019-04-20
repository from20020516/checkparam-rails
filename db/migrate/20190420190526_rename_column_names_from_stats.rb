class RenameColumnNamesFromStats < ActiveRecord::Migration[5.2]
  def change
    rename_column :stats, :"ペット:命中", :"ペット_命中"
    rename_column :stats, :"ペット:魔命", :"ペット_魔命"
    rename_column :stats, :"ペット:攻", :"ペット_攻"
    rename_column :stats, :"ペット:魔攻", :"ペット_魔攻"
    rename_column :stats, :"ペット:ダブルアタック", :"ペット_ダブルアタック"
    rename_column :stats, :"ペット:リジェネ", :"ペット_リジェネ"
    rename_column :stats, :"ペット:被ダメージ", :"ペット_被ダメージ"
    rename_column :stats, :"ペット:被物理ダメージ", :"ペット_被物理ダメージ"
    rename_column :stats, :"ペット:被魔法ダメージ", :"ペット_被魔法ダメージ"
    rename_column :stats, :"ペット:契約の履行ダメージ", :"ペット_契約の履行ダメージ"
  end
end
