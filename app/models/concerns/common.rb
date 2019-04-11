require 'active_support/concern'
module Common
  extend ActiveSupport::Concern
  include ApplicationHelper

  def checkparam(*args)
    stats = Stat.where(item_id: args).to_a
    # display 0 if use sum instead of inject(:+)
    stat_columns.map { |stat_name| [stat_name, stats.pluck(stat_name).compact.inject(:+)] }.to_h
  end
end