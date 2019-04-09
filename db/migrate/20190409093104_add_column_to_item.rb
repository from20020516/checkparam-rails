class AddColumnToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :ffo_id, :integer
  end
end
