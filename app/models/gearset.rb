class Gearset < ApplicationRecord
  include ApplicationHelper
  belongs_to :user
  belongs_to :job

  def items
    gear_id = self.slice(slots.pluck(:name)) # e.g."main" => 21758
    gears = Item.where(id: gear_id.values).to_a.map { |item| [item.id, {ja: item.ja, en: item.en, wiki_id: item.wiki_id, description: item.description}] }.to_h
    gear_id.map { |k, v| [k, gears[v]] }.to_h.with_indifferent_access
  end

  def checkparam
    # TODO: 共通化
    stats = Stat.where(id: self.slice(slots.pluck(:name)).values).to_a
    stat_names = Stat.column_names - %w[id created_at updated_at HP MP 防 Ｄ 隔 STR DEX AGI VIT INT MND CHR]
    stat_names.map { |stat_name| [stat_name, stats.pluck(stat_name).compact.sum] }.to_h
  end
end