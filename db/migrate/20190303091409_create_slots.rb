# frozen_string_literal: true

class CreateSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :slots do |t|
      t.integer   :pos
      t.string    :en
      t.integer   :img
    end
  end
end
