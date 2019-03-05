class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer :slot
      t.integer :job
      t.string  :ja
      t.string  :en
      t.timestamps
    end
  end
end
