class AddColumnToStats < ActiveRecord::Migration[5.2]
  def change
    add_column :stats, :"ペット:契約の履行ダメージ", :integer
    add_column :stats, :"召喚獣維持費", :integer
    add_column :stats, :"詠唱中断率", :integer
  end
end
