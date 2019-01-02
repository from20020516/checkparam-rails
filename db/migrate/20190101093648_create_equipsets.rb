class CreateEquipsets < ActiveRecord::Migration[5.2]
  def change
    create_table :equipsets do |t|
      t.text    :main
      t.text    :sub
      t.text    :range
      t.text    :ammo
      t.text    :head
      t.text    :neck
      t.text    :ear1
      t.text    :ear2
      t.text    :body
      t.text    :hands
      t.text    :ring1
      t.text    :ring2
      t.text    :back
      t.text    :waist
      t.text    :legs
      t.text    :feet
      t.timestamps
    end
  end
end
