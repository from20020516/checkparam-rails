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

  def stat_names
    Stat.column_names - %w[id item_id created_at updated_at Ｄ]
  end
end