class CreateWikis < ActiveRecord::Migration[5.2]
  def change
    create_table :wikis do |t|
      t.integer :item_id
      t.text :ja
      t.timestamps
    end
  end
end
