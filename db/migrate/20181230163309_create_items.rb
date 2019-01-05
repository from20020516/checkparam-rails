class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string  :ja
      t.string  :en
      t.integer :group
      t.integer :slot
      t.integer :skill
      t.integer :job
      t.integer :lv
      t.integer :itemlv
      t.timestamps
    end
  end
end
