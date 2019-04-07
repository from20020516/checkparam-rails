module ApplicationHelper
  def lang
    # Implicit return
    I18n.locale = current_user&.lang || session[:lang] ||= (request.env['HTTP_ACCEPT_LANGUAGE']&.slice(0,2) == 'ja' ? 'ja' : 'en')
  end

  def slots
    Slot.all
  end

  def gearset
    Gearset.find_or_create_by(user_id: current_user.id, job_id: current_user.job_id, set_id: current_user.set_id) # TODO: delete temporary fix.
    # Gearset.find_or_initialize_by(user_id: current_user.id, job_id: current_user.job_id, set_id: current_user.set_id)
  end
end