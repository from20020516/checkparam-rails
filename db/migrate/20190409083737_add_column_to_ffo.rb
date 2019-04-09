class AddColumnToFfo < ActiveRecord::Migration[5.2]
  def change
    add_column :ffos, :item_id, :integer
  end
end
