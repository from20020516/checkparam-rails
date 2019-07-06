# frozen_string_literal: true

class Gearset < ApplicationRecord
  belongs_to :user
  belongs_to :job

  scope :recent, -> { joins(:user).joins(:job).select('gearsets.*, jobs.ja, jobs.en, users.auth').where('main > 0 & head > 0 & body > 0 & hands > 0 & legs > 0 & feet > 0').order(updated_at: :desc).limit(10) }
  scope :current, ->(current_user) { find_or_create_by(user_id: current_user.id, job_id: current_user.job_id, set_id: current_user.set_id) }

  def gears
    slice(Slot.all.pluck(:en)) # ActiveSupport::HashWithIndifferentAccess
  end

  def items
    items = Item.current(gears.values).group_by(&:id)
    gears.map { |k, v| [k.to_sym, items[v]&.first] }.to_h.with_indifferent_access
  end

  def checkparam
    Stat.checkparam(gears.values)
  end
end
