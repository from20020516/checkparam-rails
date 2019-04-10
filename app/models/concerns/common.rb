require 'active_support/concern'
module Common
  extend ActiveSupport::Concern

  def checkparam(*args)
    # HP MP 防 Ｄ 隔 STR DEX AGI VIT INT MND CHR
    ex_stat = %w[id item_id created_at updated_at]
    stats = Stat.where(item_id: args).to_a
    stat_names = Stat.column_names - ex_stat
    stat_names.map { |stat_name| [stat_name, stats.pluck(stat_name).compact.sum] }.to_h
  end
end