class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :ja
      t.string :en
      t.string :ens
      t.string :jas
    end
  end
end
