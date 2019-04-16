class Gearset < ApplicationRecord
  include ApplicationHelper
  belongs_to :user
  belongs_to :job

  scope :latest, -> { where('main > 0 & head > 0 & body > 0 & hands > 0 & legs > 0 & feet > 0').sort_by(&:updated_at).last(2) }

  def gears
    self.slice(slots.pluck(:en))
  end

  def checkparam(*args)
    # stats = Stat.where(item_id: args).group_by(&:id)
    stats = args.map { |i| Stat.find(i) }
    # display 0 if use sum instead of inject(:+)
    stat_columns.map { |stat_name| [stat_name, stats.pluck(stat_name).compact.inject(:+)] }.to_h
  end
end