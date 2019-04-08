module ApplicationHelper
  def lang
    # Implicit return
    I18n.locale = session[:lang] ||= (request.env['HTTP_ACCEPT_LANGUAGE']&.slice(0,2) == 'ja' ? 'ja' : 'en')
  end

  def slots
    Slot.all.to_a
  end

  def items
    Item.where('job & ? > 0', 2**current_user.job_id).order(lang).to_a
  end

  def gearset
    # instead of 'find_or_initialize_by'
    Gearset.find_or_create_by(user_id: current_user.id, job_id: current_user.job_id, set_id: current_user.set_id)
  end
end