class CreateDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :descriptions do |t|
      t.text    :ja
      t.text    :en
      t.integer :HP
      t.integer :MP
      t.integer :STR
      t.integer :DEX
      t.integer :VIT
      t.integer :AGI
      t.integer :INT
      t.integer :MND
      t.integer :CHR
      t.timestamps
    end
  end
end
