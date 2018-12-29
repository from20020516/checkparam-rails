class AddColumnsToEquipment < ActiveRecord::Migration[5.2]
  def change
    add_column :equipment, :jal,   :string
    add_column :equipment, :enl,   :string
    add_column :equipment, :group, :integer
    add_column :equipment, :slot, :integer
    add_column :equipment, :skill, :integer
    add_column :equipment, :description, :text
    add_column :equipment, :job,   :integer
    add_column :equipment, :lv,    :integer
    add_column :equipment, :itemlv,:integer
  end
end
