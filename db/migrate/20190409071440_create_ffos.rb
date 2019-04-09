class CreateFfos < ActiveRecord::Migration[5.2]
  def change
    create_table :ffos do |t|
      t.text :ja
      t.timestamps
    end
  end
end
