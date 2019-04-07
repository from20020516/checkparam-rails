class CreateSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :slots do |t|
      t.integer   :pos
      t.string    :name
      t.integer   :img
    end
  end
end
