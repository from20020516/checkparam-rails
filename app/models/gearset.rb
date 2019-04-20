class Gearset < ApplicationRecord
  belongs_to :user
  belongs_to :job

  scope :latest, -> { joins(:user).joins(:job).select('gearsets.*, jobs.ja, jobs.en, users.auth').where('main > 0 & head > 0 & body > 0 & hands > 0 & legs > 0 & feet > 0').order(updated_at: :desc).limit(10) }
  scope :current_set, ->(current_user) { find_or_create_by(user_id: current_user.id, job_id: current_user.job_id, set_id: current_user.set_id) }

  # TODO: separate
  # id全部取るメソッド
  # 部位変換するメソッド
  # statsと合体して、stat取るメソッド…etc
  def gears
    hash = slice(Slot.all.pluck(:en))
    pack = Item.current_set(hash.values)
    hash.map { |key, value| [key, pack[value]&.first] }.to_h.with_indifferent_access
  end

  # TODO: scope.
  def checkparam(*args)
    gears = self.slice(Slot.all.pluck(:en)).values if args.blank?
    stats = Stat.current_stat(gears)
    stats = gears.map { |i| stats[i]&.first&.attributes&.with_indifferent_access }.compact
    Stat.names.map { |key| [key, stats.pluck(key).compact.inject(:+)] }.to_h
  end
end