class CreateDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :descriptions, id: false do |t|
      t.column :item_id, 'INTEGER PRIMARY KEY NOT NULL'
      t.text :ja
      t.text :en
      t.text :raw
      t.timestamps
    end
  end
end
