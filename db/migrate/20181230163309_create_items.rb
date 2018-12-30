class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string  :jal
      t.string  :enl
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
