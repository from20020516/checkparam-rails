class Gearset < ApplicationRecord
  belongs_to :user
  belongs_to :job

  def items
    # TODO: use where method for solve n+1
    self.slice(Slot.pluck(:name)).map{|k,v| [k, Item.find(v)] if v.present?}.compact.to_h
  end

  def checkparam
    stats = Stat.where(id: self.slice(Slot.pluck(:name)).values).to_a
    stat_names = Stat.column_names - %w[id created_at updated_at HP MP 防 Ｄ 隔 STR DEX AGI VIT INT MND CHR]
    stat_names.map { |stat_name| [stat_name, stats.pluck(stat_name).compact.sum] }.to_h
  end
end