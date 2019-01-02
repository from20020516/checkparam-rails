class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.text :ja
      t.text :en
      t.text :ens
      t.text :jas
      t.timestamps
    end
  end
end
