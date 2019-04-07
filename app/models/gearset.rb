class Gearset < ApplicationRecord
  belongs_to :user
  belongs_to :job

  def checkparam
    stats = Stat.where(id: self.slice(%w[main sub range ammo head neck ear1 ear2 body hands ring1 ring2 back waist legs feet]).values).to_a
    keys = Stat.column_names - %w[id created_at updated_at HP MP 防 Ｄ 隔 STR DEX AGI VIT INT MND CHR]
    keys.map {|key|
      [key, stats.pluck(key).compact.sum]
    }.to_h
  end
end