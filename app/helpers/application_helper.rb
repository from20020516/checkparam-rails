module ApplicationHelper

  def user
    User.find_by_id(current_user&.id) # return nil if current_user not present.
  end

  def lang
    user&.lang || (request.env['HTTP_ACCEPT_LANGUAGE']&.slice(0,2) == 'ja' ? 'ja' : 'en')
  end

  def slots
    Slot.all
  end

  def current_gears
    Item.where('job & ? > 0', 2**user.job_id).order(lang)
  end

  def gearset
    Gearset.find_or_initialize_by(user_id: user.id, job_id: user.job_id, set_id: user.set_id)
  end
end