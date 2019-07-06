# frozen_string_literal: true

class CreateGearsets < ActiveRecord::Migration[5.2]
  def change
    create_table :gearsets do |t|
      t.integer   :user_id, null: false
      t.integer   :job_id, default: 1, null: false
      t.integer   :set_id, default: 1, null: false
      t.integer   :main
      t.integer   :sub
      t.integer   :range
      t.integer   :ammo
      t.integer   :head
      t.integer   :neck
      t.integer   :ear1
      t.integer   :ear2
      t.integer   :body
      t.integer   :hands
      t.integer   :ring1
      t.integer   :ring2
      t.integer   :back
      t.integer   :waist
      t.integer   :legs
      t.integer   :feet
      t.timestamps
    end
  end
end
