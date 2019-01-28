module ApplicationHelper
  require 'byebug'
  def gearlist(current_user)
    Item.where('job & ? > 0', 2**current_user.jobid).order(current_user.lang)
  end
end