module ApplicationHelper
  def slots
    Slot.all.to_a
  end

  def items
    Item.where('job & ? > 0', 2**current_user.job_id).order(current_user.lang).to_a
  end

  def gearset
    # instead of 'find_or_initialize_by'
    Gearset.find_or_create_by(user_id: current_user.id, job_id: current_user.job_id, set_id: current_user.set_id)
  end

  def stat_columns
    Stat.column_names - %w[id item_id created_at updated_at Ｄ]
  end

  def allow_sets
    10
  end

  def cards
    Gearset.where('main > 0 & head > 0 & body > 0 & hands > 0 & legs > 0 & feet > 0').last(3)
  end
end