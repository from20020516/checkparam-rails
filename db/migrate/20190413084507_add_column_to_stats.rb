class AddColumnToStats < ActiveRecord::Migration[5.2]
  def change
    add_column :stats, :"ペット:契約の履行ダメージ", :integer
  end
end
