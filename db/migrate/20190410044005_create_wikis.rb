# frozen_string_literal: true

class CreateWikis < ActiveRecord::Migration[5.2]
  def change
    create_table :wikis do |t|
      t.text :ja
      t.timestamps
    end
  end
end
