class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.json   :name
      t.string :ens
      t.string :jas
    end
  end
end
