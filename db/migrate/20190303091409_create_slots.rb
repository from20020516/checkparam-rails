class CreateSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :slots do |t|
      t.integer   :pos
      t.string    :en
      t.string    :ja
      t.integer   :img
      t.timestamps
    end
  end
end
