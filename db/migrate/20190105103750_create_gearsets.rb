class CreateGearsets < ActiveRecord::Migration[5.2]
  def change
    create_table :gearsets do |t|
      t.integer   :user_id, null: false
      t.integer   :jobid, default: 1, null: false
      t.integer   :setid, default: 1, null: false
      t.integer   :main, default: 0, null: false
      t.integer   :sub, default: 0, null: false
      t.integer   :range, default: 0, null: false
      t.integer   :ammo, default: 0, null: false
      t.integer   :head, default: 0, null: false
      t.integer   :neck, default: 0, null: false
      t.integer   :ear1, default: 0, null: false
      t.integer   :ear2, default: 0, null: false
      t.integer   :body, default: 0, null: false
      t.integer   :hands, default: 0, null: false
      t.integer   :ring1, default: 0, null: false
      t.integer   :ring2, default: 0, null: false
      t.integer   :back, default: 0, null: false
      t.integer   :waist, default: 0, null: false
      t.integer   :legs, default: 0, null: false
      t.integer   :feet, default: 0, null: false
      t.timestamps
    end
  end
end
